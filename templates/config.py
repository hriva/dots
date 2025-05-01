# config.py
import json
import os


def load_settings():
    default_settings = {"debug_mode": False, "log_level": "INFO"}

    try:
        with open("user_settings.json", "r") as f:
            user_settings = json.load(f)
    except FileNotFoundError:
        user_settings = {}

    # Merge user settings with defaults
    merged_settings = {**default_settings, **user_settings}

    # Override with environment variables
    merged_settings["debug_mode"] = os.environ.get("DEBUG_MODE", "False") == "True"

    return merged_settings


config = load_settings()

# main.py
from config import config

print(config)
