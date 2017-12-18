--section 2

select * from Employee;
select * from Employee where LASTNAME = 'King';
select * from Employee where FIRSTNAME = 'Andrew' and REPORTSTO is null;
select * from Album order by TITLE desc;
select FIRSTNAME from customer order by CITY asc;

INSERT into GENRE (GENREID, NAME) values (26, 'cool stuff');
INSERT into GENRE(GENREID, NAME) values (27, 'songs i like');
INSERT INTO Employee (EmployeeId, LastName, FirstName)
values (9, 'Reidy', 'Jack');
INSERT INTO Employee (EmployeeId, LastName, FirstName) 
values (10, 'Reidy', 'John');
INSERT into Customer (customerid, firstname, lastname, email) 
values (60, 'Reidy', 'Jack', '123fake@email.com');
INSERT into Customer (customerid, firstname, lastname, email) 
values (61, 'Galvin', 'John', '456real@fake.com');

update Customer
Set FIRSTNAME = 'Robert', LASTNAME = 'WALTER'
where FIRSTNAME = 'Aaron' and LASTNAME = 'Mitchell';
update artist set name = 'CCR' where name = 'Creedence Clearwater Revival';

select * from invoice where BILLINGADDRESS like 'T%';
select * from invoice where TOTAL between 15 and 30;
select * from employee where HIREDATE between 
TO_DATE('2003-06-01', 'yyyy-mm-dd') and TO_DATE('2004-03-01', 'yyyy-mm-dd');

alter table invoice drop constraint FK_INVOICECUSTOMERID;
ALTER TABLE Invoice ADD CONSTRAINT FK_InvoiceCustomerId
    FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
    on delete cascade;
ALTER TABLE invoiceline drop constraint FK_INVOICELINEINVOICEID;
ALTER TABLE InvoiceLine ADD CONSTRAINT FK_InvoiceLineInvoiceId
    FOREIGN KEY (InvoiceId) 
    REFERENCES Invoice (InvoiceId) on delete cascade;
delete from customer where FIRSTNAME = 'Robert' and LASTNAME = 'WALTER';






--section 3





create or replace Function getTime return timestamp is
begin return sysdate; end;/
declare
    today timestamp;
begin
    today := getTime;
    dbms_output.put_line(today);
end;
/
create or replace function getlength(x in varchar2) 
return integer as z varchar(200);
begin 
    z := length(x);
    return z;
end;
/
select getlength(name) from mediatype;

create or replace function myavg
return number as z number;
begin 
    select avg(total) into z from invoice;
    return z;
end;
/
select myavg from dual;

create or replace function mymax
return number as z number (10, 2);
begin 
    select max(unitprice) into z from track;
    return z;
end;
/
select mymax from dual;
create or replace function myavg2
return number as z number;
begin 
    select avg(unitprice) into z from invoiceline;
    return z;
end;
/
select myavg2 from dual;

create or replace function bornafter(x date)
return sys_refcursor is refcur sys_refcursor;
begin
    open refcur for 'select firstname, lastname from employee 
    where birthdate >= :x' using x;
    return refcur;
end;
/

declare 
x date;
fn employee.firstname%type;
ln employee.lastname%type;
returncur sys_refcursor;
begin
x := to_date('1968', 'yyyy');
select bornafter(x) into returncur from dual;
dbms_output.put_line('here');
    Loop
        fetch returncur into fn, ln;
        exit when returncur%notfound;
        DBMS_OUTPUT.PUT_LINE(fn || ' ' || ln);
    end loop;
end;
/







--section 4








create or replace procedure getemployeename(s out sys_refcursor)
as begin
 open s for select firstname, lastname from employee;
end;
/
declare
    s sys_refcursor;
    fn employee.firstname%type;
    ln employee.lastname%type;
begin 
    getemployeename(s);
    loop 
        fetch s into fn, ln;
        exit when s%notfound;
        dbms_output.put_line(fn || ', ' || ln);
    end loop;
    close s;
end;
/

create or replace procedure updatepersonalemployee(newemail in varchar2, employeeid in number)
as begin
    update employee set email = newemail where employeeid = employee.employeeid;
    commit;
end;
/
select firstname, lastname, email from employee where employeeid = 7;
begin
    updatepersonalemployee('newemail@email.com', 7);
end;
/
create or replace procedure managedby(s out sys_refcursor, inemployeeid in number)
as begin 
    open s for select emp.employeeid, emp.firstname, emp.lastname 
    from employee e join employee emp on e.reportsto = emp.employeeid 
    where e.employeeid = inemployeeid; 
end;
/
declare
    s sys_refcursor;
    fn employee.firstname%type;
    ln employee.lastname%type;
    employeeid employee.employeeid%type;
    inemployeeid number;
begin 
    inemployeeid := 2;
    managedby(s, inemployeeid);
    loop 
        fetch s into employeeid, fn, ln;
        exit when s%notfound;
        dbms_output.put_line(employeeid || ', ' || fn || ', ' || ln);
    end loop;
    close s;
end;
/
create or replace procedure getcompname(compname out varchar2, fn out varchar2, ln out varchar2, cid in number)
as begin
    select company into compname from customer where customerid = cid;
    select firstname into fn from customer where customerid = cid;
    select lastname into ln from customer where customerid = cid;
end;
/
declare
    cname varchar2(200);
    nf varchar2(200);
    nl varchar2(200);
    cid number;
begin
    cid := 5;
    getcompname(cname, nf, nl, cid);
    dbms_output.put_line(cname || ' ' || nf || ' ' || nl);
end;
/








--section 5


begin
    delete from INVOICELine where invoiceid = 21;
    delete from invoice where invoiceid = 21;
    commit;
end;
/
select * from invoice;

create or replace procedure insertcust(cid in number, fn in varchar2, ln in varchar2, email in varchar2)
as begin
    insert into customer (customerid, firstname, lastname, email) 
        values(cid, fn, ln, email);
    commit;
end;
/
begin
insertcust(61, 'jack', 'reidy', 'myemail@gmail.com');
end;
/
select * from customer where customerid = 61;

--section 6



create or replace trigger triggertest
after insert on employee
begin
    DBMS_OUTPUT.PUT_LINE('triggered');
end;
/

create or replace trigger trigger2
after update on album 
begin
    DBMS_output.put_line('this isnt an insert but it is an update');
end;
/

create or replace trigger trigger3
after delete on customer 
begin
    DBMS_output.put_line('hey im done');
end;








--section 7



select * from employee e join employee emp on emp.employeeid = e.reportsto;

select * from customer c inner join 
invoice i on c.customerid = i.customerid;
select c.firstname, c.lastname, i.invoiceid, i.total 
from customer c left outer join invoice i on c.customerid = i.customerid;
select art.name, al.title 
from artist art right join album al on art.artistid = al.artistid;
select art.name from artist art 
cross join album al where art.artistid = al.artistid order by art.name asc;
select * from employee e join employee emp on emp.reportsto = e.employeeid;

select * from ((employee e inner join customer c 
on e.employeeid = c.supportrepid) 
inner join (invoice iv inner join invoiceline il 
on iv.invoiceid = il.invoiceid) on c.customerid = iv.customerid)
inner join ((((genre g inner join track t on g.genreid = t.genreid)
inner join (album al inner join artist art on al.artistid = art.artistid)
on t.albumid = al.albumid) inner join 
(playlist pl inner join playlisttrack plt 
on plt.playlistid = pl.playlistid) on plt.trackid = t.trackid) 
inner join mediatype m on m.mediatypeid = t.mediatypeid) 
on il.trackid = t.trackid;