# Dashboard Admin Module (Frontend)

This module provides a dashboard for administrators to view key performance indicators (KPIs) of the event.

## How to use

The dashboard is available at the `/admin/dashboard` route. You need to be logged in as an `ADMIN` or `STAFF` to access it.

The dashboard will fetch and display the following information for the selected date (defaults to today):

*   **Overview KPIs:** Attendance rate, morning check-ins, and afternoon check-ins.
*   **Hourly Check-ins:** A bar chart showing the number of check-ins per hour.
*   **Check-ins by Type:** A pie chart showing the distribution of check-ins by type.

You can change the date by clicking on the calendar icon in the app bar.

## How to run tests

To run the tests for this module, you can run the following command:

```bash
flutter test test/modules/dashboard_admin/pages/home_admin_dashboard_page_test.dart
```