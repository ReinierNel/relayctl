import typer
import requests

app = typer.Typer()

@app.command()
def list():
    response = requests.get(f"http://127.0.0.1:8000/relays")
    typer.echo(response.json())

@app.command()
def add(gpio: int):
    body = {"gpio": gpio}
    response = requests.post(f"http://127.0.0.1:8000/relays/add", json = body)
    typer.echo(response.json())

@app.command()
def delete(id: int):
    response = requests.delete(f"http://127.0.0.1:8000/relays/delete/{id}")
    typer.echo(response.json())

@app.command()
def status(id: int):
    response = requests.get(f"http://127.0.0.1:8000/relays/{id}")
    typer.echo(response.json())

@app.command()
def on(id: int):
    response = requests.get(f"http://127.0.0.1:8000/relays/{id}/on")
    typer.echo(response.json())

@app.command()
def off(id: int):
    response = requests.get(f"http://127.0.0.1:8000/relays/{id}/off")
    typer.echo(response.json())

@app.command()
def switch (id: int):
    response = requests.get(f"http://127.0.0.1:8000/relays/{id}/off")
    typer.echo(response.json())


if __name__ == "__main__":
    app()
