Select
    ord.order_id,
	concat(cus.first_name,' ',cus.last_name	 ) AS 'customers',
	cus.city, 
	cus.state,
	ord.order_date,
	sum(ite.quantity) AS 'total_units',
	sum(ite.quantity * ite.list_price) AS 'revenue',
	pro.product_name,
	cat.category_name,
	sto.store_name,
	CONCAT(sta.first_name,' ',sta.last_name) AS 'sales_rep'
from sales.orders ord
join sales.customers cus
on ord.customer_id = cus.customer_id
join sales.order_items ite
on ord.order_id = ite.order_id
Join production.products pro
on ite.product_id = pro.product_id
JOIN production.categories cat
on pro.category_id = cat.category_id 
join sales.stores sto
on ord.store_id = sto.store_id
JOIN sales.staffs sta
ON ord.staff_id = sta.staff_id
Group BY
 ord.order_id,
	concat(cus.first_name,' ',cus.last_name	 ),
	cus.city, 
	cus.state,
	ord.order_date,
	pro.product_name,
	cat.category_name,
	sto.store_name,
	CONCAT(sta.first_name,' ',sta.last_name) 
