import azure.functions as func
from app.logging_conf import configure_logging
from app.handlers.hello import bp as hello_bp

logger = configure_logging()

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)
app.register_functions(hello_bp)

# Optional: warmup ping for Premium plans (no-op handler)
@app.function_name(name="warmup")
@app.schedule(schedule="0 */10 * * * *")  # every 10 minutes
def warmup(mytimer: func.TimerRequest) -> None:
    logger.info("warmup tick", schedule="10m")
