import requests
from bs4 import BeautifulSoup as soup
import smtplib
import os
import schedule
import time


def check_price():

    g_user = os.environ.get("gmail_user")
    g_pwd = os.environ.get("gmail_password")
    url = "https://www.amazon.in/dp/B09JWHZ862?ref=myi_title_dp"
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                             "Chrome/96.0.4664.45 Safari/537.36"}
    page = requests.get(url, headers=headers)
    s = soup(page.content, "html.parser")
    title = s.find("span", "a-size-large product-title-word-break").get_text().strip()
    price = s.find("span", "a-size-medium a-color-price priceBlockBuyingPriceString").get_text().strip()[1:]

    if price > "168.00":
        smtp = smtplib.SMTP_SSL("smtp.gmail.com", 465)
        smtp.ehlo()
        smtp.login(g_user, g_pwd)
        subject = "Spade Poly price"
        body = price
        msg = f"subject:{subject} \n\n body:{body}"
        smtp.sendmail(g_user, g_user, msg)
        smtp.quit()

schedule.every(1).seconds.do(check_price)
while 1:
    schedule.run_pending()
    time.sleep(1)
    
