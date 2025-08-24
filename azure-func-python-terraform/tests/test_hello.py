import json
import azure.functions as func

from app.handlers.hello import hello

def make_request(body: dict) -> func.HttpRequest:
    return func.HttpRequest(
        method="POST",
        url="/api/hello",
        headers={"Content-Type":"application/json"},
        params={},
        route_params={},
        body=json.dumps(body).encode("utf-8")
    )

def test_hello_ok():
    req = make_request({"name": "Alice"})
    resp = hello(req)
    assert resp.status_code == 200
    payload = json.loads(resp.get_body())
    assert payload["message"] == "Hello, Alice!"

def test_hello_validation():
    req = make_request({"name": ""})
    resp = hello(req)
    assert resp.status_code == 422
