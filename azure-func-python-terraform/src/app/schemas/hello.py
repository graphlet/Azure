from pydantic import BaseModel, Field

class HelloRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
