import requests


def main():
    r = requests.post("https://ipinfo.io")
    # Поставь тут брейкпоинт с помощью F9 и запусти дебаггер, нажав F5
    data = r.json()
    print("Your IP:", data["ip"])


if __name__ == "__main__":
    main()
