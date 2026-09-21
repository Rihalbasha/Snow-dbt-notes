-----windows functions
-----CTE
-----set operators

---*CTE= common tbale expressionit willact as like temptable/session 
---- set operators=union,union all ,nterset,minus

---window functions:
--


---*CTE= common tbale expressionit willact as like temptable/session 
select*from employees;
with cte_emp as
    (
    select*from employees
    )select*from cte_emp;

    
---to add like next hike
----(for adding the new colum like hike and given the5 or 10%  will use below code the specific is  (salary*10)/100 as next_hike )


                        --ex1for 5%
                        
select employee_ID,
    first_name,
    salary,
    (salary*5)/100 as next_hike
    from employees
    
                            --ex2 for 10%
                            

select employee_ID,
    first_name,
    salary,
    (salary*10)/100 as next_hike
    from employees

-----to find the who got the hike less than 500 or 600 or700 will add the (where next_hike< 500or 600or 700:)

    select employee_ID,
    first_name,
    salary,
    (salary*10)/100 as next_hike
    from employees
    where next_hike<500;     

-----there is a one more example with the differnt code(in the we have added the "with cte_sal as" and rest queary added in to the "()" and select *from cte_sal rest all remains the same

with cte_sal as
(
 select employee_ID,
    first_name,
    salary,
    (salary*10)/100 as next_hike
    from employees
)
select*from cte_sal
where next_hike<600;





----------set operators-----------
--there are 4 operators 
--1.UNION:it will remove the duplicates from query results
--2.INION ALL:it will not remove the duplicates from the query results
--3.INTERSECT: only common values will get print
--4.MINUS: it should present in only A not in B table(A-B)


--1.UNION;----
--its will remove douplicates

select employee_id from employees
    union
select employee_id from dependents;

--2.UNION ALL;----
--it will show all 

select employee_id from employees
    union all
select employee_id from dependents;

--3.INTERSECT----

select employee_id from employees
    intersect
select employee_id from dependents;

--4.MINUS----
select employee_id from employees
minus
select employee_id from dependents;

-----we can use multble also like--(in union place we can use union all intersect minus) below is just for ex
select employee_id,first_name from employees
 union
 select employee_id,first_name from dependents;

 ---what if we add CTE into the union,union all, minus.

 with cte_emp as
 (
select employee_id,first_name from employees
 union
 select employee_id,first_name from dependents
 )
 select* from cte_emp
 order by employee_id




 -------------window functions--------------
--ROW_NUMBER:
--RANK
--DENSE_RANK
--LEAD
--LAG



select employee_id,
    salary,
    row_number()over(order by salary desc)as RID,
     rank()over(order by salary desc)as RNK,
    dense_rank()over(order by salary desc)AS DRNK,
    LEAD (SALARY)OVER(ORDER BY SALARY DESC)AS NEXT_VAL,
    LAG (SALARY)OVER(ORDER BY SALARY DESC)AS NEXT_VAL
   from employees;

   tASK :
 
 
  MID    MONTH_NAME AMOUNT
  ------------------------
  1     JAN         20000
  2      FEB         30000
  3      MAR        10000
  ..
  ...
  ...
  12    DEC         45000
 
 
  I WNAT TO SEE PROFIT OR LOSS  (lEAD /LAG)
 
    MID    MONTH_NAME AMOUNT      PROFIT_LOSS
  -----------------------------------------
  1     JAN         20000          nA
  2      FEB        30000        10000
  3      MAR        10000        -20000
  ..
  ...
  ...
  12    DEC         45000

  ---group by
---having
---handling null values
---sub quireis
---conditional statemnets


select*from employees;
---1 group by

--if we need to use the group by we can add (*)like dep or salary 
SELECT DEPARTMENT_ID FROM EMPLOYEES;

SELECT distinct DEPARTMENT_ID FROM EMPLOYEES;


order by 1;

SELECT DEPARTMENT_ID count(*) FROM EMPLOYEES
order by DEPARTMENT_ID;



SELECT salary,COUNT(*) AS employee_count
FROM employees
GROUP BY salary
ORDER BY employee_count DESC;

---find manger he/she under more than5employees
select manager_id,count(*)from employees
    group by manager_id
    having count(*)>5;

---finding the depert_id it has more than3 employess

select department_id,count(*)from employees
    group by department_id
    having count(*)>3;
    --ex2

    select department_id,count(*)from employees
    group by department_id
    having count(*)<2;

    ----how to find the doup(licate names
    select first_name,count(*)from employees
    group by first_name
    having count(*)>1;
    ---finding emplyee who is having more salary

    select salary,count(*)from employees
    group by salary
    having count(*)>1;
    --or insert the queari in the queary called as sub queary

    select*from employees where salary in (
    select salary from employees
    group by salary
    having count(*)>1
    );

    ---ex2
     select*from employees where first_name in(
     select first_name,from employees
    group by first_name
    having count(*)>1
    );

    ---how to find the 2max salary 

    select max(salary)from employees
        where salary not  in(select max(salary)from employees)

   select*from employees where salary in(
   select max(salary)from employees
        where salary not in(select max(salary)from employees)
        )


    -----date should be present in both emp/dep
    select*from employees where employee_id in (select employee_id from dependents);
    
    -----employee data should ont in the dep
    
    select*from employees where employee_id not in (select employee_id from dependents);
    
    -----date only presentin depand not in emp table
    
    select*from dependents where employee_id not in (select employee_id from employees);


    ---how to handle null values very imp

select*from employees;

select*from employees where phone_number is null;

select*from employees where phone_number is not null;

select employee_id,
    first_name,
    phone_number,
    coalesce((phone_number,'na')
        from employees;

  -----count () what ever will give like * or 10 or 20 its will showon only emplyess count    

 select count(*) from employees;

 select count(10) from employees;
  select count(30) from employees;
   select count(-10) from employees;
-- the results will change because there is some null values so its will exclude those
    select count(phone_number) from employees;

------ conditional statemnets--------------

-------task-----

;SELECT 
    eid,
    age,
    CASE 
        WHEN age >= 20 THEN 'MAJOR'
        ELSE 'MINOR'
    END AS status 
FROM (
    VALUES 
        (101, 19),
        (102, 20),
        (103, 30)
) AS t(eid, age);

------task2---------
SELECT 
    ID,
    CASE 
        WHEN id = 1 THEN 'Monday'
        WHEN id = 2 THEN 'Tuesday'
        WHEN id = 3 THEN 'Wednesday'
        WHEN id = 4 THEN 'Thursday'
        WHEN id = 5 THEN 'Friday'
        WHEN id = 6 THEN 'Saturday'
        WHEN id = 7 THEN 'Sunday'
        ELSE 'invalid_day'
    END AS day_name
    FROM (
    VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9),(10)
) AS t(id);
    
    


   



    
    
    



