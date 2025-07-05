import requests
import os


def main():
    r = requests.post("https://ipinfo.io")
    data = r.json()
    # Поставь тут брейкпоинт с помощью F9 и запусти дебаггер, нажав F5
    print("Your IP:", data["ip"])


if __name__ == "__main__":
    main()
