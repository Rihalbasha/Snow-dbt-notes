

--JOINS--
--joins;in roder to combine the orfeych 2 or more tables date 

--type of Joins


    --Innder:the combination of the both the tables it will featch,only matched value it will featch.
    
    --Left:innder join = renaing values from left side table ,if the value not match print as null
                    or  
    
    --right:innder join = renaing values from right side table ,if the value not match print as null
    
    --full:the cobminatio of right and left 
    --sefl:the table it self if yoy wantto perform any joinswe are goi
    --cross:
----code examCOMPLETE_TASK_GRAPHS(

create table tab_A(id int);
create table tab_B(ID int);
insert into tab_a(id)values(1),(3),(4),(5),(6);
insert into tab_b(id)values(1),(2),(3),(6),(7),(8);


select*from tab_a,tab_b;
select*from tab_b;

---to write the jions 
--innerjoin

select A.*,B.*
    from TAB_A A inner join tab_b B
    on A.id=B.id;
--left join
select A.*,B.*
    from TAB_A A left join tab_b B
    on A.id=B.id;
---right join

select A.*,B.*
    from TAB_A A right join tab_b B
    on A.id=B.id;
---full join
select A.*,B.*
    from TAB_A A full join tab_b B
    on A.id=B.id;
---cross joins
select A.*,B.*
    from TAB_A A 
    cross join tab_b B;

select*from employees;

    select X.employee_id,
            x.salary,
            x.first_name,
            x.department_id,
            y.department_name
        from employees X inner join departments Y
            on X.department_id=y.department_id

            --left join

select X.employee_id,
            x.salary,
            x.first_name,
            x.department_id,
            y.department_name
        from employees X left join departments Y
            on X.department_id=y.department_id

            ---right join

select X.employee_id,
            x.salary,
            x.first_name,
            x.department_id,
            y.department_name
        from employees X inner join departments Y
            on X.department_id=y.department_id

            ----full join



    SELECT 
    x.employee_id,
    x.salary,
    x.first_name,
    x.department_id,
    y.department_name,
    c.city 
FROM employees x 
FULL JOIN departments y
    ON x.department_id = y.department_id
LEFT JOIN locations c
    ON y.location_id = c.location_id;



-----self joins-------


---------cross joins-------


    






