

---create a table---


select*from hostel.boys_pg.candidate;

-------for chcking the result.

select*from hostel.candidate;

-----adding
alter table candidate add column amount float;

------remove

alter table candidate drop column amount;

---------need to fill the null values.


update candidate
  set amount =1000

    where sid=102

    update candidate
        set amount =5000
        where sid=101

        update candidate
        set amount=1500
        where sid=103

    ---------for 3 candidates.
    
  update candidate  set amount =1000 where sid =101;
update candidate set amount =2000 where sid =102;
 update candidate set amount =300 where sid =103;


-------- if we need specific colums.

select name,amount from candidate;

--------we need to know order wise 

select name,amount from candidate
    order by amount desc;

SELECT * FROM candidate WHERE iLIKE(name, 'a%');


SELECT * FROM hostel.boys_pg.candidate;

SELECT * FROM hostel.girls_pg.candidate;
SELECT * FROM hostel.coliving.candidate;

----------
select name,pno from hostel.boys_pg.candidate;







