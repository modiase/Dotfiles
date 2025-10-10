
import os
import sys
from pathlib import Path

import click
from loguru import logger

sys.path.insert(0, str(Path(__file__).parent))
from utils import (
    setup_logging,
    image_up_to_date,
    upload_to_gcs,
    check_nix,
    check_gcloud_config,
    check_ssh_access,
    build_gce_image,
    check_terraform,
    deploy_with_terraform,
    run_command_env_context,
)


def perform_checks(repo_root: Path, project_id: str, remote_host: str) -> bool:
    with logger.contextualize(task="checking-prerequisites"):
        logger.info("🔍 Performing dry run checks...")

        checks = [
            (
                "Nix flake",
                lambda: check_nix(
                    repo_root,
                    "nixosConfigurations.hermes.config.system.build.googleComputeImage",
                ),
            ),
            ("Terraform config", lambda: check_terraform(repo_root)),
            ("gcloud config", lambda: check_gcloud_config(project_id)),
            ("SSH access", lambda: check_ssh_access(remote_host)),
        ]

        all_passed = True

        for check_name, check_func in checks:
            try:
                if not check_func():
                    all_passed = False
            except Exception as e:
                logger.error(f"Check '{check_name}' failed with exception: {e}")
                all_passed = False

        if all_passed:
            logger.success("✅ All dry run checks passed!")
        else:
            logger.error("❌ Some dry run checks failed")

        return all_passed


@click.group(invoke_without_command=True)
@click.option(
    "-v", "--verbose", count=True, help="Increase verbosity (use multiple times)"
)
@click.option(
    "--project-id", default="modiase-infra", envvar="PROJECT_ID", help="GCP project ID"
)
@click.option(
    "--remote-host", default="herakles", envvar="REMOTE_HOST", help="Remote build host"
)
@click.pass_context
def cli(ctx, verbose: int, project_id: str, remote_host: str):
    ctx.ensure_object(dict)
    ctx.obj["verbose"] = verbose
    ctx.obj["project_id"] = project_id
    ctx.obj["remote_host"] = remote_host

    setup_logging(verbose)

    if ctx.invoked_subcommand is None:
        ctx.invoke(build)


@cli.command()
@click.pass_context
def build(ctx):
    verbose = ctx.obj["verbose"]
    project_id = ctx.obj["project_id"]
    remote_host = ctx.obj["remote_host"]

    repo_root = Path(os.environ.get("REPO_ROOT", Path(__file__).parent.parent))

    with run_command_env_context(
        CI="1", TERM="dumb", NO_COLOR=os.environ.get("NO_COLOR", "false")
    ):
        with logger.contextualize(task="building-image"):
            logger.info("Building hermes image")
            tarball_path = build_gce_image(
                repo_root,
                "nixosConfigurations.hermes.config.system.build.googleComputeImage",
                remote_host,
                verbose,
            )

        with logger.contextualize(task="uploading-image"):
            if image_up_to_date(tarball_path, "gs://modiase-infra/images/hermes-nixos-latest.tar.gz", project_id):
                logger.info("Skipping upload (image is up to date)")
            else:
                upload_to_gcs(tarball_path, "gs://modiase-infra/images/hermes-nixos-latest.tar.gz", project_id)

        logger.success("Hermes image build and upload complete.")


@cli.command()
@click.option(
    "--no-build", is_flag=True, help="Skip building, only deploy existing image"
)
@click.pass_context
def deploy(ctx, no_build: bool):
    verbose = ctx.obj["verbose"]
    project_id = ctx.obj["project_id"]
    remote_host = ctx.obj["remote_host"]

    repo_root = Path(os.environ.get("REPO_ROOT", Path(__file__).parent.parent))

    tarball_path = None

    with run_command_env_context(
        CI="1", TERM="dumb", NO_COLOR=os.environ.get("NO_COLOR", "false")
    ):
        if no_build:
            logger.info("Skipping build and upload")

        if not no_build:
            with logger.contextualize(task="building-image"):
                tarball_path = build_gce_image(
                    repo_root,
                    "nixosConfigurations.hermes.config.system.build.googleComputeImage",
                    remote_host,
                    verbose,
                )

            with logger.contextualize(task="uploading-image"):
                if image_up_to_date(tarball_path, "gs://modiase-infra/images/hermes-nixos-latest.tar.gz", project_id):
                    logger.info("Skipping upload (image is up to date)")
                else:
                    upload_to_gcs(tarball_path, "gs://modiase-infra/images/hermes-nixos-latest.tar.gz", project_id)

        with logger.contextualize(task="deploying-terraform"):
            logger.info("Deploying with Terraform")
            deploy_with_terraform(
                Path.cwd(),
                verbose,
                (
                    "module.hermes.google_compute_image.hermes_nixos",
                    "module.hermes.google_compute_instance.hermes",
                ),
            )

        logger.success(
            "Hermes deploy complete"
            if no_build
            else "Hermes image build and deploy complete"
        )


@cli.command()
@click.pass_context
def check(ctx):
    project_id = ctx.obj["project_id"]
    remote_host = ctx.obj["remote_host"]

    repo_root = Path(os.environ.get("REPO_ROOT", Path(__file__).parent.parent))

    logger.info("🔍 Running prerequisite checks")
    sys.exit(0 if perform_checks(repo_root, project_id, remote_host) else 1)


if __name__ == "__main__":
    cli()
