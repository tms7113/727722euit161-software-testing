package com.example;

import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.LogManager;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;

import freemarker.log.Logger;
import io.github.bonigarcia.wdm.WebDriverManager;

public class Ixigo {

     public static org.apache.log4j.Logger logger = LogManager.getLogger(Ixigo.class);
    
    @Test
    public void test() {
         WebDriverManager.chromedriver().setup();
        WebDriver driver=new ChromeDriver();


        try {
            driver.get("https://www.ixigo.com/");
            ExtentReports report = new ExtentReports();
            ExtentSparkReporter eReporter = new ExtentSparkReporter("D:\\software\\demo\\src\\test\\java\\com\\example\\report1\\ExtentReport.html");
           report.attachReporter(eReporter);
             ExtentTest test = report.createTest("Test One1");
            File f=new File("D:\\dbankdemo.xlsx");
            FileInputStream fr=new FileInputStream(f);
            XSSFWorkbook wb=new XSSFWorkbook(fr);
            XSSFSheet st=wb.getSheet("Sheet3");
            XSSFRow r=st.getRow(1);
            String a= r.getCell(0).getStringCellValue();
            String b=r.getCell(1).getStringCellValue();
            WebElement roundTripButton = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[1]/div[1]/div/button[2]"));
            roundTripButton.click();

            WebElement fromInput = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[1]/div[1]/div[1]/div"));
            fromInput.sendKeys(a);

            WebElement fromDropdownOption = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[1]/div[1]/div[3]/div[1]/li"));
            fromDropdownOption.click();

            WebElement toInput = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[1]/div[2]/div[1]/div"));
            toInput.sendKeys(b);

            WebElement toDropdownOption = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[1]/div[2]/div[3]/div[1]/li"));
            toDropdownOption.click();

            WebElement departureDate = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[2]/div[1]/div/div/div/div/p[2]"));
            departureDate.sendKeys("Nov-6-2023");
            WebElement returnDate = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[2]/div[2]/div/div[1]/div/div/p[2]"));
            returnDate.sendKeys("Nov-8-2023");
            WebElement travellersClassSection = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[3]/div/div/div/div/p[2]"));
            travellersClassSection.click();
            WebElement adultsInput = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[3]/div[2]/div/div[1]/div[1]/div[2]/div/button[3]"));
            adultsInput.click();

            WebElement childInput = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[3]/div[2]/div/div[1]/div[2]/div[2]/div/button[3]"));
            childInput.click();
            WebElement businessClassOption = driver.findElement(By.xpath("/html/body/main/div[2]/div[1]/div[3]/div[2]/div[3]/div[2]/div/div[1]/div[5]/div/div[3]/p"));
            businessClassOption.click();
            File screenshotFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            FileUtils.copyFile(screenshotFile, new File("screenshot2.png"));
            if (returnDate.getAttribute("value").contains("08 Nov")) {
                System.out.println("Return date contains '08 Nov'. Test Case 1 passed.");
                logger.info("It is true");
            } else {
                System.out.println("Return date does not contain '08 Nov'. Test Case 1 failed.");
                logger.info("It is false");
            }

            driver.get("https://www.ixigo.com/");
            WebElement aboutUsLink = driver.findElement(By.xpath("/html/body/main/div[3]/div[2]/div/div[2]/div[1]/p[1]/a"));
            aboutUsLink.click();
             File screenshotFile1 = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(screenshotFile1, new File("screenshot1.png"));

            String currentUrl = driver.getCurrentUrl();
            if (currentUrl.contains("about")) {
                System.out.println("Redirected URL contains 'about'. Test Case 2 passed.");
                logger.info("It is true"); 
            } else {
                System.out.println("Redirected URL does not contain 'about'. Test Case 2 failed.");
                logger.info("It is false");
            }

        } catch (Exception e) {
            System.out.println("Exception occurred: " + e.getMessage());
        } 
    }
}
