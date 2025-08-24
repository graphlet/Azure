import json
import azure.functions as func
from pydantic import ValidationError

from app.schemas.hello import HelloRequest
from app.services.greeting_service import GreetingService

bp = func.Blueprint()

@bp.route(route="hello", methods=["POST"], auth_level=func.AuthLevel.FUNCTION)
def hello(req: func.HttpRequest) -> func.HttpResponse:
    try:
        data = req.get_json()
    except ValueError:
        return func.HttpResponse(
            json.dumps({"error": "Invalid JSON"}),
            status_code=400,
            mimetype="application/json",
        )
    try:
        payload = HelloRequest.model_validate(data)
    except ValidationError as e:
        return func.HttpResponse(
            e.json(),
            status_code=422,
            mimetype="application/json",
        )

    message = GreetingService().greet(payload.name)
    return func.HttpResponse(
        json.dumps({"message": message}),
        status_code=200,
        mimetype="application/json",
    )
