import argparse
import logging
import re
import subprocess
import sys
from pathlib import Path
from typing import Set, Optional

import yaml

SUCCESS_LEVEL = 25
WORKFLOW_DIR = Path(".github/workflows")


def get_git_remote_url() -> Optional[str]:
    """Get Git repository URL automatically"""
    try:
        remote_url = subprocess.check_output(
            ["git", "config", "--get", "remote.origin.url"], stderr=subprocess.STDOUT, text=True
        ).strip()

        # Convert SSH format to HTTPS
        if remote_url.startswith("git@github.com:"):
            return remote_url.replace("git@github.com:", "https://github.com/").replace(".git", "")

        return remote_url.replace(".git", "")

    except subprocess.CalledProcessError:
        logging.warning("Failed to detect Git remote URL")
    except FileNotFoundError:
        logging.warning("Git command not found")
    return None


def parse_secrets_from_yaml(yaml_path: Path) -> Set[str]:
    """Parse used secrets from YAML file"""
    secrets = set()
    secret_pattern = re.compile(r"\$\{\{\s*secrets\.(\w+)\s*\}\}")

    try:
        with open(yaml_path, "r") as f:
            workflow_data = yaml.safe_load(f)

        def scan_node(node):
            if isinstance(node, dict):
                for v in node.values():
                    scan_node(v)
            elif isinstance(node, list):
                for item in node:
                    scan_node(item)
            elif isinstance(node, str):
                secrets.update(secret_pattern.findall(node))

        scan_node(workflow_data)
        return secrets

    except yaml.YAMLError as e:
        logging.error(f"YAML parsing failed: {str(e)}")
        return set()
    except Exception as e:
        logging.error(f"File read error: {str(e)}")
        return set()


def check_workflow_secrets(workflow_name: str):
    """Check and prompt for required secrets"""
    workflow_file = WORKFLOW_DIR / f"{workflow_name}.yaml"

    if not workflow_file.exists():
        logging.error(f"Workflow '{workflow_name}' not found!")
        return

    required_secrets = parse_secrets_from_yaml(workflow_file)

    if required_secrets:
        repo_url = get_git_remote_url() or "https://github.com/your-org/your-repo"
        secrets_url = f"{repo_url}/settings/secrets/actions"

        logging.info("\nThis workflow requires the following GitHub Secrets:")
        max_len = max(len(s) for s in required_secrets)
        for secret in sorted(required_secrets):
            logging.log(
                SUCCESS_LEVEL if secret.startswith("CI_") else logging.WARNING,
                f"  {secret.ljust(max_len)} ⟶  {secrets_url}",
            )
        logging.warning("\n❗ Ensure these secrets are configured in repository settings!")


class ColorFormatter(logging.Formatter):
    COLORS = {SUCCESS_LEVEL: "\033[92m", logging.WARNING: "\033[93m", logging.ERROR: "\033[91m", "RESET": "\033[0m"}

    def format(self, record):
        color = self.COLORS.get(record.levelno, "")
        return f"{color}{super().format(record)}{self.COLORS['RESET']}"


def setup_logging():
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logging.addLevelName(SUCCESS_LEVEL, "SUCCESS")

    def success(self, msg, *args, **kwargs):
        if self.isEnabledFor(SUCCESS_LEVEL):
            self._log(SUCCESS_LEVEL, msg, args, **kwargs)

    logging.Logger.success = success

    handler = logging.StreamHandler()
    handler.setFormatter(ColorFormatter("%(message)s"))
    logger.addHandler(handler)


def discover_workflows():
    """Discover available workflows"""
    workflows = {}
    for file in WORKFLOW_DIR.glob("*"):
        if file.suffix in (".yaml", ".template"):
            name = file.stem if file.suffix == ".yaml" else file.stem.replace(".yaml", "")
            status = "enabled" if file.suffix == ".yaml" else "disabled"
            workflows[name] = max(workflows.get(name, {}), {status: file}, key=len)
    return workflows


def validate_workflow(name: str) -> bool:
    """Validate workflow existence"""
    return any([(WORKFLOW_DIR / f"{name}.yaml").exists(), (WORKFLOW_DIR / f"{name}.yaml.template").exists()])


def list_workflows():
    """List all workflows"""
    workflows = discover_workflows()
    if not workflows:
        logging.warning("No workflows found!")
        return

    logging.info("Available workflows:")
    max_width = max(len(name) for name in workflows.keys()) + 2
    for name, data in workflows.items():
        status = next(iter(data.keys()))
        logging.log(
            SUCCESS_LEVEL if status == "enabled" else logging.WARNING,
            f"  {name.ljust(max_width)} [{'●' if status == 'enabled' else '○'}] {status}",
        )


def git_commit(workflow_name: str, action: str):
    """Commit changes to Git"""
    try:
        subprocess.run(["git", "add", str(WORKFLOW_DIR)], check=True, capture_output=True, text=True)
        commit_message = f"ci: {action} workflow {workflow_name}"
        subprocess.run(["git", "commit", "-m", commit_message], check=True, capture_output=True, text=True)
        logging.getLogger().success("Changes committed successfully")
    except subprocess.CalledProcessError as e:
        logging.error(f"Git operation failed: {e.stderr}")


def toggle_workflow(action: str, name: str, commit: bool = False):
    """Enable/disable workflow"""
    if not validate_workflow(name):
        available = list(discover_workflows().keys())
        logging.error(f"Workflow '{name}' not found! Available: {available}")
        sys.exit(1)

    src = WORKFLOW_DIR / f"{name}.yaml.template" if action == "enable" else WORKFLOW_DIR / f"{name}.yaml"
    dest = src.with_suffix("" if action == "enable" else ".yaml.template")

    if not src.exists():
        conflict = "enabled" if action == "enable" else "disabled"
        logging.error(f"Workflow '{name}' is already {conflict}!")
        sys.exit(2)

    src.rename(dest)

    if action == "enable":
        check_workflow_secrets(name)

    if commit:
        git_commit(name, action)

    logging.getLogger().success(f"Successfully {action}d {name} workflow")


def main():
    setup_logging()
    parser = argparse.ArgumentParser(prog="poe action")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # List command
    subparsers.add_parser("list", help="List all workflows")

    # Toggle command
    toggle_parser = subparsers.add_parser("toggle", help="Enable/disable workflow")
    toggle_group = toggle_parser.add_mutually_exclusive_group(required=True)
    toggle_group.add_argument("--enable", action="store_true")
    toggle_group.add_argument("--disable", action="store_true")
    toggle_parser.add_argument("name", type=str, help="Workflow name")
    toggle_parser.add_argument("--commit", action="store_true", help="Commit changes automatically")

    args = parser.parse_args()

    if args.command == "list":
        list_workflows()
    elif args.command == "toggle":
        action = "enable" if args.enable else "disable"
        toggle_workflow(action, args.name, args.commit)


if __name__ == "__main__":
    main()
