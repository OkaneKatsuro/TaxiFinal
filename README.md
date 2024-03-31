1) список обьектов 

Pass (User)
    Id
    Fname
    Lname
    List<Point> adddressList
    history

Point
    lat
    long
    name
    descr
    ?passName

History
    List<order> list

Order
    StartDate
    length
    driverName
    List<Point> route
    activeStatus (true,false) - выполняется сейчас
    confirmed (true,false) - подвержден или не подтвержден водителем

-------------------
Driver
    id
    Fname
    Lname
    activeStatus(true, false)
        -true
    CurrentOrder    
    List<order> history

-------------------------


register_page - при нажатии на войти сделать локальное создание обьекта и запись его в фаербэйз
если обьект уже существует то сделать перезапись полей имени


сделать сервисы обновления текущей гео и гео машины


2) связи  логика bloc


сделать переходы