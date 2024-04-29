package com.testing;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.Select;
import org.testng.annotations.*;

import io.github.bonigarcia.wdm.WebDriverManager;

public class OpenTableTest {

    WebDriver driver;
    final Logger log=Logger.getLogger(getClass());
    JavascriptExecutor JS;
    Select Sel;

    @BeforeMethod
    public void BeforeMethod()throws Exception
    {
        PropertyConfigurator.configure("D:\\Programs\\Web Develouping\\Software Testing\\Log4J\\cw2\\Log4j.properties");
        WebDriverManager.chromedriver().setup();
        driver=new ChromeDriver();
        driver.get("https://opentable.com");
        driver.manage().window().maximize();
        JS=(JavascriptExecutor)driver;
        Thread.sleep(3000);
    }

    @DataProvider(name = "Place")
    public String[][] data()throws Exception
    {
        String a[][]=new String[1][1];

        FileInputStream fis=new FileInputStream("D:\\Programs\\Web Develouping\\Software Testing\\Log4J\\cw2Data.xlsx");
        XSSFWorkbook wb=new XSSFWorkbook(fis);
        Sheet S=wb.getSheetAt(0);

        a[0][0]=S.getRow(1).getCell(0).toString();
        wb.close();
        fis.close();

        return a;
    }

    @Test(dataProvider = "Place")
    public void Test(String a)throws Exception
    {
        if(driver.getCurrentUrl().equals("https://www.opentable.com/"))
        log.info("Page Opened Successfully");
        else
        log.info("Page Open Failed");
        Thread.sleep(2000);
        driver.findElement(By.xpath("//*[@id=\"home-page-autocomplete-input\"]")).sendKeys(a);
        Thread.sleep(2000);
        log.info("Place Entered Successfully");
        Thread.sleep(2000);
        driver.findElement(By.xpath("//*[@id=\"mainContent\"]/header/div/span/div/div/div[2]/div[2]/button")).click();
        Thread.sleep(2000);
        JS.executeScript("window.scrollBy(0,500,'smooth')", "");
        Thread.sleep(2000);
        driver.findElement(By.xpath("//*[@id=\"mainContent\"]/div/section/div[6]/div/label[4]")).click();
        Thread.sleep(2000);
        driver.findElement(By.xpath("//*[@id=\"mainContent\"]/div/div/div[2]/div[1]/div[2]/div[1]/div[1]/a/h6")).click();
        Thread.sleep(2000);
        ArrayList<String>Tabs=new ArrayList<String>(driver.getWindowHandles());
        Thread.sleep(2000);
        driver.switchTo().window(Tabs.get(1));
        Thread.sleep(3000);
        JS.executeScript("window.scrollBy(0,500,'smooth')", "");
        TakeSS("details.jpg");
        Thread.sleep(2000);
        Sel = new Select(driver.findElement(By.xpath("//*[@id=\"restProfileSideBarDtpPartySizePicker\"]")));
        Thread.sleep(2000);
        Sel.selectByValue("4");
        Thread.sleep(2000);
        driver.findElement(By.xpath("//*[@id=\"restProfileSideBarDtpDayPicker\"]/div")).click();
        Thread.sleep(2000);
        WebElement nextbut=driver.findElement(By.xpath("//*[@id=\"restProfileMainContentDtpDayPicker-wrapper\"]/div/div/div/div/div[2]/button[2]"));
        for(int i=0;i<8;i++,Thread.sleep(2000))
        nextbut.click();
        driver.findElement(By.xpath("//*[@id=\"restProfileMainContentDtpDayPicker-wrapper\"]/div/div/div/table/tbody/tr[3]/td[2]/button")).click();
        Thread.sleep(2000);
        Sel=new Select(driver.findElement(By.xpath("//*[@id=\"restProfileMainContenttimePickerDtpPicker\"]")));
        Thread.sleep(6000);
        Sel.selectByVisibleText("6:30 PM");
        Thread.sleep(2000);
        
    }

    void TakeSS(String a)throws Exception
    {
        TakesScreenshot TS=(TakesScreenshot)driver;
        File src=TS.getScreenshotAs(OutputType.FILE);
        File des=new File("D:\\Programs\\Web Develouping\\Software Testing\\Log4J\\"+a);
        FileUtils.copyFile(src, des);
        log.info("ScreenShot taken Successfully!");
    }

    // @AfterMethod
    // public void AfterMethod()
    // {
    //     driver.quit();
    // }

}
