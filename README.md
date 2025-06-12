# Woocommerce-manage-products-api

## Overview

Woocommerce API integration with Zecat.
Created for setting all the categories, products and their variants on Woocommerce API

### Operations

* Create Zecat Argentina products through categories
* Update Zecat Argentina products
* Create Zecat Chile products through categories
* Update Zecat Chile products

#### Operation Commands

* CategoriesSetupJob.perform_async
* ProductsIterationJob.perform_async
* ProductSetupJob.perform_async(zecat_id)

### Improvements

* Manage Timeout Exception for Attachments upload

### Dependencies

* 2.7.8
* Rails 6.1.7

### System Dependencies

* Environment Variables
  * WOOCOMMERCE_ARGENTINA_ENDPOINT
  * ARGENTINA_WOOCOMMERCE_CONSUMER_KEY
  * ARGENTINA_WOOCOMMERCE_CONSUMER_SECRET
  * ZECAT_ARGENTINA_ENDPOINT
  * ARGENTINA_BEARER_TOKEN
  * ARGENTINA_PRICE_INCREASE

  * WOOCOMMERCE_CHILE_ENDPOINT
  * CHILE_WOOCOMMERCE_CONSUMER_KEY
  * CHILE_WOOCOMMERCE_CONSUMER_SECRET
  * ZECAT_CHILE_ENDPOINT
  * CHILE_BEARER_TOKEN
  * CHILE_PRICE_INCREASE

  * ADMIN_USERNAME
  * ADMIN_PASSWORD
  * HEALTH_CHECK_USERNAME
  * HEALTH_CHECK_PASSWORD
  * SIDEKIQ_REDIS_URL
  * RAILS_MASTER_KEY
  * NOTIFICATION_EMAIL
  * NOTIFICATION_EMAIL_PASSWORD
  * SUPPORT_EMAIL

  * PRINTING_TYPE_ATTRIBUTE
  * PRINTING_TYPE_DEFAULT_VALUE
