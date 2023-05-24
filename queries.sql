-- Multi-Table Sorgu Pratiği

-- Tüm ürünler(product) için veritabanındaki ProductName ve CategoryName'i listeleyin. (77 kayıt göstermeli)

select p.ProductName,c.CategoryName from Product as p
join Category as c on c.Id = p.CategoryId

-- 9 Ağustos 2012 öncesi verilmiş tüm siparişleri(order) için sipariş id'si (Id) ve gönderici şirket adını(CompanyName)'i listeleyin. (429 kayıt göstermeli)

select o.Id as 'OrderId',c.CompanyName as 'SirketAdi' from [Order] as o
join Customer as c on c.Id = o.CustomerId
where o.OrderDate<'2012-08-09'

-- Id'si 10251 olan siparişte verilen tüm ürünlerin(product) sayısını ve adını listeleyin. ProdcutName'e göre sıralayın. (3 kayıt göstermeli)
select Count(p.ProductName) as 'UrunSayisi' from OrderDetail od
join Product p on od.ProductId=p.Id
where OrderId = 10251
order by p.ProductName
-- Her sipariş için OrderId, Müşteri'nin adını(Company Name) ve çalışanın soyadını(employee's LastName). Her sütun başlığı doğru bir şekilde isimlendirilmeli. (16.789 kayıt göstermeli)
select o.Id,c.CompanyName,e.LastName from [Order] o
join Customer c on o.CustomerId = c.Id
join Employee e on e.Id = o.EmployeeId

------------ ESNEK GÖREVLER ----------------------------
----- 1.Soru Her gönderici tarafından gönderilen gönderi sayısını bulun. ---
select CustomerId,count(CustomerId) as 'SiparisSayisi' from [Order]
group by CustomerId
order by count(CustomerId) desc
------2.Soru Sipariş sayısına göre ölçülen en iyi performans gösteren ilk 5 çalışanı bulun.-----------------
select e.FirstName,e.LastName,Count(o.EmployeeId) as 'ToplamSiparisSayisi' 
from [Order] o
join Employee e on o.EmployeeId = e.Id

group by o.EmployeeId
order by Count(o.EmployeeId) desc
limit 5
----- 3.Soru Gelir olarak ölçülen en iyi performans gösteren ilk 5 çalışanı bulun. ----
select e.FirstName,e.LastName,Round(Sum(od.Quantity*od.UnitPrice*(1-od.Discount)),3) as 'ToplamSatisTutari' from OrderDetail od
join [Order] o on od.OrderId = o.Id
join [Employee] e on o.EmployeeId = e.Id

group by o.EmployeeId
order by Sum(od.Quantity*od.UnitPrice) desc
limit 5
----- 4.Soru En az gelir getiren kategoriyi bulun------------------
select c.CategoryName, Round(Sum(od.Quantity*od.UnitPrice*(1-od.Discount)),3) as 'ToplamSatisTutari' 
from OrderDetail od
join [Order] o on od.OrderId = o.Id
join [Product] p on od.ProductId = p.Id
join Category c on c.Id = p.CategoryId

group by p.CategoryId
order by Sum(od.Quantity*od.UnitPrice)
limit 1
---- 5.Soru En çok siparişi olan müşteri ülkesini bulun.-------
select c.Country,count(c.Country) as 'SiparisSayisi' from [Order] o
join Customer c on o.CustomerId = c.Id
group by c.Country
order by count(c.Country)  desc
limit 1