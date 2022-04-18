#!/usr/bin/python

import typer
import requests
import json
from tabulate import tabulate

app = typer.Typer()

# relays
@app.command()
def get_relays ():

    response = requests.get(f"http://127.0.0.1:8000/relays")

    if response.status_code == 200:
        typer.echo(tabulate(response.json(), headers='keys', tablefmt='fancy_grid'))
    else:
        typer.echo(typer.style(
            "Error adding new relay",
            fg=typer.colors.RED
         ))


@app.command()
def add_relay (gpio: int):
    body = {"gpio": gpio}
    response = requests.post(f"http://127.0.0.1:8000/relays/add", json = body)

    if response.status_code == 200:
        typer.echo(typer.style(
            "New relay added",
            fg=typer.colors.GREEN
         ))
    else:
        typer.echo(typer.style(
            "Error adding new relay",
            fg=typer.colors.RED
         ))


@app.command()
def delete_relay (id: str):

    response = requests.delete(f"http://127.0.0.1:8000/relays/delete/{id}")

    if response.status_code == 200:
        typer.echo(typer.style(
            f"Relay {id} deleted",
            fg=typer.colors.GREEN
         ))
    else:
        typer.echo(typer.style(
            f"Error deleting relay {id}",
            fg=typer.colors.RED
         ))


@app.command()
def relay (id: str, status: str):

    if status == "on":
        response = requests.get(f"http://127.0.0.1:8000/relays/{id}/on")
    elif status == "off":
        response = requests.get(f"http://127.0.0.1:8000/relays/{id}/off")
    elif status == "status":
        response = requests.get(f"http://127.0.0.1:8000/relays/{id}")
    else:
        typer.echo(typer.style(
            "Error status acceptable values are on or off",
            fg=typer.colors.RED
        ))
        raise typer.Exit()

    if response.status_code == 200:
        if status == "status":
            data = [response.json()]
            typer.echo(tabulate(data, headers='keys', tablefmt='fancy_grid'))
        else:
            typer.echo(typer.style(
                f"Switching Relay {id} {status}",
                fg=typer.colors.GREEN
            ))
    else:
        typer.echo(typer.style(
            f"Error swtcing relay {id} {status}",
            fg=typer.colors.RED
         ))


# switches
@app.command()
def get_switches ():

    response = requests.get(f"http://127.0.0.1:8000/switches")

    if response.status_code == 200:
        typer.echo(tabulate(response.json(), headers='keys', tablefmt='fancy_grid'))
    else:
        typer.echo(typer.style(
            "Error adding new relay",
            fg=typer.colors.RED
         ))


@app.command()
def add_switch (relay_id: int, mode: int, action: int):
    body = {"relay_id": relay_id,"mode": mode,"action": action}
    response = requests.post(f"http://127.0.0.1:8000/switches/add", json = body)

    if response.status_code == 200:
        typer.echo(typer.style(
            "New switch mapping added",
            fg=typer.colors.GREEN
         ))
    else:
        typer.echo(typer.style(
            "Error adding switch mapping",
            fg=typer.colors.RED
         ))


@app.command()
def delete_switch (id: str):

    response = requests.delete(f"http://127.0.0.1:8000/switches/delete/{id}")

    if response.status_code == 200:
        typer.echo(typer.style(
            f"Switch {id} deleted",
            fg=typer.colors.GREEN
         ))
    else:
        typer.echo(typer.style(
            f"Error deleting switch {id}",
            fg=typer.colors.RED
         ))


# Schedules

@app.command()
def get_schedules ():

    response = requests.get(f"http://127.0.0.1:8000/schedules")

    if response.status_code == 200:
        typer.echo(tabulate(response.json(), headers='keys', tablefmt='fancy_grid'))
    else:
        typer.echo(typer.style(
            "Error adding new relay",
            fg=typer.colors.RED
         ))


@app.command()
def add_schedules (relay_id: int, action: int, start: str, end: str, mon: int, tue: int, wed: int, thu: int, fri: int, sat: int, sun: int):
    body = {
        "relay_id": relay_id,
        "action": action,
        "start": start,
        "end": end,
        "mon": mon,
        "tue": tue,
        "wed": wed,
        "thu": thu,
        "fri": fri,
        "sat": sat,
        "sun": sun
    }

    response = requests.post(f"http://127.0.0.1:8000/schedules/add", json = body)

    if response.status_code == 200:
        typer.echo(typer.style(
            "New schedules added",
            fg=typer.colors.GREEN
         ))
    else:
        typer.echo(typer.style(
            "Error adding schedules",
            fg=typer.colors.RED
         ))


@app.command()
def delete_schedules (id: str):

    response = requests.delete(f"http://127.0.0.1:8000/schedules/delete/{id}")

    if response.status_code == 200:
        typer.echo(typer.style(
            f"schedules {id} deleted",
            fg=typer.colors.GREEN
         ))
    else:
        typer.echo(typer.style(
            f"Error deleting schedules {id}",
            fg=typer.colors.RED
         ))


if __name__ == "__main__":
    app()
