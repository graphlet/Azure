from pydantic import Field
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_env: str = Field(default="local", alias="APP_ENV")
    app_name: str = "azure-func-python-ref"

    class Config:
        extra = "allow"

settings = Settings()  # Reads from env/app settings at import time
