from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()

url = "http://fwb.emr.fortiseahk.com"
i = 1
for _ in range(10):

    driver.get(url)

    driver.find_element(By.ID,"authUser").send_keys("admin")
    driver.find_element(By.ID,"clearPass").send_keys("pass")
    driver.find_element(By.ID,"login-button").click()
    print(i)
    i += 1
driver.quit()
