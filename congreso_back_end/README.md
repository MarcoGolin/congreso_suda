# Dashboard Admin Module

This module provides a set of read-only endpoints to retrieve Key Performance Indicators (KPIs) for the admin dashboard.

## How to activate

To activate the dashboard module, you need to add the following property to your `application.properties` file:

```properties
dashboard.admin.enabled=true
```

By default, the module is disabled.

## How to use

The endpoints are available under `/api/dashboard/admin/v1`. You need to have `ADMIN` or `STAFF` role to access them.

### Endpoints

*   `GET /api/dashboard/admin/v1/meta`: Returns whether the dashboard is enabled.
*   `GET /api/dashboard/admin/v1/kpis/overview?date=YYYY-MM-DD`: Returns an overview of the KPIs for the given date.
*   `GET /api/dashboard/admin/v1/kpis/by-checkin-type?date=YYYY-MM-DD`: Returns KPIs grouped by check-in type.
*   `GET /api/dashboard/admin/v1/series/hourly?date=YYYY-MM-DD`: Returns a time series of check-ins per hour.
*   `GET /api/dashboard/admin/v1/series/quarters?date=YYYY-MM-DD`: Returns a time series of check-ins per 15 minutes.
*   `GET /api/dashboard/admin/v1/tops/workshops?date=YYYY-MM-DD&limit=5`: Returns the top workshops by check-ins.
*   `GET /api/dashboard/admin/v1/noshow?date=YYYY-MM-DD`: Returns a list of participants who have not checked in.

## How to test

To run the tests for this module, you can run the following command:

```bash
./mvnw test
```
