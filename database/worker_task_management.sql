CREATE TABLE `tbl_workers` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL
);

ALTER TABLE `tbl_workers`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tbl_workers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `tbl_workers` AUTO_INCREMENT = 1000;
