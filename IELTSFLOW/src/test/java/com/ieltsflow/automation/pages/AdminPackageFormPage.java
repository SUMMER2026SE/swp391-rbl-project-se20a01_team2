package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class AdminPackageFormPage extends BasePage {

    public AdminPackageFormPage(WebDriver driver) {
        super(driver);
    }

    private By nameInput = By.name("name");
    private By durationInput = By.name("durationMonths");
    private By priceInput = By.name("price");
    private By descriptionInput = By.name("description");
    private By saveBtn = By.cssSelector("button[type='submit']");

    public void fillFormAndSubmit(String name, String duration, String price, String description) {
        if (name != null) type(nameInput, name);
        if (duration != null) type(durationInput, duration);
        if (price != null) type(priceInput, price);
        if (description != null) type(descriptionInput, description);
        click(saveBtn);
    }
    
    public void submitForm() {
        click(saveBtn);
    }
}
