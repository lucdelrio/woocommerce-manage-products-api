# Woocommerce-manage-products-api

## Render APP

- Habilitar Servicios en:
https://dashboard.render.com/project/prj-crqpfgbtq21c73f06d40/environment/evm-crqpfgbtq21c73f06d4g

- Ingresar en Cada servicio que figura suspendido > Settings > Resume Web Service / Resume Background Worker
y Para la base de datos Resume Database

- Esperar unos minutos a que todos los servicios figuren con status Available


## Detener Servicios
Es conveniente detener los servicios para disminuir los cargos de los mismos.
https://dashboard.render.com/project/prj-crqpfgbtq21c73f06d40/environment/evm-crqpfgbtq21c73f06d4g

### Servicios a Detener
- app
- sidekiq-worker
- woocommerce-manage-products

### Cómo suspender?
Ingresar en Cada servicio que figura activo > Settings > Suspend Web Service / Suspend Background Worker
y Para la base de datos Suspend Database

**Antes de suspender los servicios, ir a la pestaña de Ocupado y verificar que no haya ítems en la sección de Trabajos o que sólo se encuentren ítems del tipo: AttachmentsSetupJob**


## Actualización de Productos

https://app-spz2.onrender.com/sidekiq (ver apartado de username y password)

Ir a la pestaña Cron -> Para ejecutar una tarea, botón "Enqueue Now" | "Encolar ahora"
**Antes de ejecutar una tarea, ir a la pestaña de Ocupado y verificar que no haya ítems en la sección de Trabajos o que sólo se encuentren ítems del tipo: AttachmentsSetupJob**

### Orden de ejecución

#### Tareas para borrar categorías que ya no existan en Zecat
- argentina_categories_cleanup_job
- chile_categories_cleanup_job

#### Tarea para crear/actualizar categorías
- categories_setup_job

#### Tarea para borrar productos que ya no existan en Zecat
- products_cleanup_job

#### Tarea para crear/actualizar productos
- argentina_product_setup_job
- chile_product_setup_job

#### Tarea para enviar notificaciones sobre personalizaciones de productos
- product_customization_job

## Verificación de Productos

- Ingresar a https://app-spz2.onrender.com/admin (ver apartado de username y password)

Posibilidad de consultar en cada sección los ítems.
Los más útiles serán Categories y Products.


### Verificar username y password

- Ingresando en el servicio app > Environment:
Descubrir los valores para ADMIN_USERNAME y ADMIN_PASSWORD