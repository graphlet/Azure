class GreetingService:
    def greet(self, name: str) -> str:
        name = (name or "").strip() or "World"
        return f"Hello, {name}!"
