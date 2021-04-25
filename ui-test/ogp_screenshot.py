import os
import time

from selenium import webdriver

if not os.path.exists("ogp"):
    os.mkdir("ogp")

PATHS = {
    "/cards/weekly-map": (959, 520),
    "/cards/whats-new": (959, 520),
    "/cards/self-disclosures": (959, 520),
    "/cards/details-of-confirmed-cases": (959, 520),
    "/cards/number-of-confirmed-cases": (959, 500),
    "/cards/monitoring-number-of-confirmed-cases": (959, 500),
    "/cards/untracked-rate": (959, 500),
    "/cards/positive-rate": (959, 500),
    "/cards/number-of-hospitalized": (959, 500),
    "/cards/attributes-of-confirmed-cases": (959, 480),
    "/cards/number-of-confirmed-cases-by-municipalities": (959, 480),
    "/cards/number-of-tested": (959, 520),
    "/cards/monitoring-number-of-reports-to-covid19-consultation-desk": (959, 500),
    "/cards/number-of-reports-to-covid19-telephone-advisory-center": (959, 500),
}

options = webdriver.ChromeOptions()
options.headless=True
options.add_argument("--hide-scrollbars")
options.add_argument("--incognito")

driver = webdriver.Chrome(options=options)

for lang in ("ja", "en"):
    if not os.path.exists("ogp/{}".format(lang)):
        os.mkdir("ogp/{}".format(lang))
    for path, size in PATHS.items():
        driver.set_window_size(*size)
        driver.get(
            "http://localhost:8000{}?ogp=true".format(
                path if lang == "ja" else "/{}{}".format(lang, path)
            )
        )
        path = path.replace("/cards/", "").replace("/", "_")
        driver.save_screenshot(
            "ogp/{}.png".format(
                path if lang == "ja" else "{}/{}".format(lang, path)
            )
        )
