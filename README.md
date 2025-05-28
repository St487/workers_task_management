# Worker Task Management System

## 📱 Flutter App
A mobile app for workers to :
- Register and log in
- View their profile
- See a list of assigned tasks
- Submit task completion reports

## 🔙 Backend API (PHP)
Located in the `php/` folder. Includes:
- `register_worker.php`
- `login_worker.php`
- `get_works.php` – Retrieves tasks assigned to logged-in worker
- `submit_work.php` – Submits a task completion report
- `db_connect.php`

## 🗃️ Database Script
Located in the `database/` folder:
- `worker_task_management.sql` – Contains:
  - `workers` table
  - `tbl_works` table with 10 sample tasks
  - `tbl_submissions` table for storing work submissions

## 🔗 Demo Video (YouTube)
Login, Register and Profile:
[Click here to watch the demo video on YouTube](https://youtu.be/e_mDFLAwSVw)
Task list and submission:
[Click here to watch the demo video on YouTube](https://youtu.be/e_mDFLAwSVw)

### Flutter
1. Open the `worker_task_management/` folder in VS Code or Android Studio.
2. Run `flutter pub get`.
3. Run on emulator or real device.

### PHP API
1. Copy `php/` to your XAMPP `htdocs` folder.
2. Start Apache and MySQL.
3. Ensure your Flutter app points to the correct IP for the API.

## 👨‍💻 Author
- Name: ONG SIEW TING
- Matric Number: 299430

### Sample Data Preview
```sql
INSERT INTO `tbl_works` (`id`, `title`, `description`, `assigned_to`, `date_assigned`, `due_date`, `status`) VALUES
('Prepare Material A', 'Prepare raw material A for assembly.', 1, '2025-05-25', '2025-05-28', 'pending'),
('Inspect Machine X', 'Conduct inspection for machine X.', 2, '2025-05-25', '2025-05-29', 'pending'),
('Clean Area B', 'Deep clean work area B before audit.', 3, '2025-05-25', '2025-05-30', 'pending'),
('Test Circuit Board', 'Perform unit test for circuit batch 4.', 4, '2025-05-25', '2025-05-28', 'pending'),
('Document Process', 'Write SOP for packaging unit.', 5, '2025-05-25', '2025-05-29', 'pending'),
('Paint Booth Check', 'Routine check on painting booth.', 1, '2025-05-25', '2025-05-30', 'pending'),
('Label Inventory', 'Label all boxes in section C.', 2, '2025-05-25', '2025-05-28', 'pending'),
('Update Database', 'Update inventory in MySQL system.', 3, '2025-05-25', '2025-05-29', 'pending'),
('Maintain Equipment', 'Oil and tune cutting machine.', 4, '2025-05-25', '2025-05-30', 'pending'),
('Prepare Report', 'Prepare monthly performance report.', 5, '2025-05-25', '2025-05-30', 'pending');