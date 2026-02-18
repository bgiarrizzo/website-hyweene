import os
import shutil

from config import settings

def create_symlink(src, dst):
    """Create a symbolic link from src to dst."""
    try:
        if os.path.islink(dst) or os.path.exists(dst):
            os.remove(dst)
        os.symlink(src, dst)
        print(f"Created symlink: {dst} -> {src}")
    except OSError as e:
        print(f"Error creating symlink: {e}")


def cleanup_releases(releases_path, keep=3):
    """Delete old releases, keeping only the most recent ones."""
    try:
        # List releases sorted by timestamp (newest first)
        releases = sorted(os.listdir(releases_path), reverse=True)
        # Keep only the most recent 'keep' releases
        old_releases = releases[keep:]
        for release in old_releases:
            # Construct the full path to the release
            release_path = os.path.join(releases_path, release)
            print(f"Deleting old release: {release_path}")
            if os.path.isdir(release_path):
                shutil.rmtree(release_path)
    except OSError as e:
        print(f"Error deleting old releases: {e}")


def release_site():
    """Release the site by creating a symlink to the latest build and deleting old releases."""

    # Create a symlink to the latest build
    create_symlink(settings.RELEASE_PATH, settings.CURRENT_RELEASE_PATH)

    # Delete old releases
    cleanup_releases(settings.RELEASES_PATH)

