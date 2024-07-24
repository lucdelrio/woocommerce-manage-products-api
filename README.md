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

CategoriesSetupJob.perform_async
ProductsIterationJob.perform_async
ProductSetupJob.perform_async(zecat_id)

### Improvements

* Manage Timeout Exception for Attachments upload

### Dependencies

* 2.7.8
* Rails 6.1.7

### System Dependencies

* Environment Variables
  * WOOCOMMERCE_ENDPOINT
  * WOOCOMMERCE_CONSUMER_KEY
  * WOOCOMMERCE_SECRET
  * ZECAT_ENDPOINT
  * ADMIN_USERNAME
  * ADMIN_PASSWORD
  * HEALTH_CHECK_USERNAME
  * HEALTH_CHECK_PASSWORD
  * SIDEKIQ_REDIS_URL
  * RAILS_MASTER_KEY
