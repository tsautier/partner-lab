from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
import time
import random

driver = webdriver.Chrome()

url = "http://emr.fortiseahk.com"

for _ in range(8):
    driver.get(url)

    # Wait for the login elements to be present
    wait = WebDriverWait(driver, 10)
    auth_user = wait.until(EC.visibility_of_element_located((By.ID, "authUser")))
    clear_pass = wait.until(EC.visibility_of_element_located((By.ID, "clearPass")))
    login_button = wait.until(EC.element_to_be_clickable((By.ID, "login-button")))

    # Clear existing input values
    auth_user.clear()
    clear_pass.clear()

    # Simulate typing username and password with delays
    for char in "admin":
        auth_user.send_keys(char)
        time.sleep(random.uniform(0.1, 0.3))  # Add random delay between keystrokes
    for char in "Sup3r123$":
        clear_pass.send_keys(char)
        time.sleep(random.uniform(0.1, 0.3))  # Add random delay between keystrokes

    # Move the mouse to a random position on the page
    actions = ActionChains(driver)
    actions.move_by_offset(random.randint(1, 100), random.randint(1, 100))
    actions.perform()

    # Scroll the page
    driver.execute_script("window.scrollBy(0, 300);")  # Scroll down by 300 pixels

    # Click the login button
    login_button.click()

    # Wait for the next action or page to load
    time.sleep(2)  # Add a delay to wait for the next action or page to load

driver.quit()
