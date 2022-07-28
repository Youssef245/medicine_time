import express from 'express';
import bodyParser from 'body-parser';
import dbConnection from './connection.js';
import tedious from 'tedious';

var jsonParser = bodyParser.json()

const PORT = 8080;
const app = express();

app.use(express.json())
app.use(express.urlencoded({ extended: true }))

//http://localhost:8080/medicines

app.listen(
    PORT,
    ()=> console.log(`it's alive on http://localhost:${PORT}`)
)

dbConnection.connect();

app.post('/history',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var s = `insert into histories VALUES (N'${body.pillName}'
    ,'${body.dose_quantity}',N'${body.dose_units}',N'${body.date}',${body.hour},${body.action}
    ,${body.minute},${body.alarm_id},N'${body.dose_units2}',${body.user_id},${body.dose_quantity2}
    ,${body.day_of_week})`;
    console.log(s);
    var request = new Request(s,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                history : 'Created Successfully'
            });
        }
    });

    dbConnection.execSql(request);
});

app.post('/alarms',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var request = new Request(`insert into alarms VALUES (${body.alarm_id},${body.hour}
    ,${body.minute},N'${body.pillName}',N'${body.date}','${body.dose_quantity}',N'${body.dose_units}'
    ,${body.day_of_week},N'${body.dose_units2}',${body.user_id},'${body.dose_quantity2}'
    )`,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                alarm : 'Created Successfully'
            });
        }
    });

    dbConnection.execSql(request);
});

app.delete('/alarms/:id',(req, res)=>{
    var param = req.params;
    var Request = tedious.Request; 
    var request = new Request(`delete from alarms where alarm_id = ${param.id}`,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                alarm : 'Deleted Successfully'
            });
        }
    });

    dbConnection.execSql(request);
});

app.get('/medicines',async (req,res)=>{
    var o = {};
    o["data"]=[];
    var Request = tedious.Request; 
    var request = new Request("SELECT medicines.medicine_name , med_category.cat_name from medicines , "+
    "med_category where med_category.id = medicines.cat_id",function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
    });
    request.on('row',function(columns){
        var medicineObject={};
        columns.forEach(function(column) {
            medicineObject[column.metadata.colName] = column.value.replace('\r\n','');
        });
        o["data"].push(medicineObject);
    });
    request.on('doneInProc', function () {
        console.log(o["data"].length)
        res.send(o);
     });
    dbConnection.execSql(request);
});

app.get('/medCategories',async (req,res)=>{
    var o = {};
    o["data"]=[];
    var Request = tedious.Request; 
    var request = new Request("SELECT med_category.cat_name from med_category",function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
    });
    request.on('row',function(columns){
        var medicineObject={};
        columns.forEach(function(column) {
            medicineObject[column.metadata.colName] = column.value.replace('\r\n','');
        });
        o["data"].push(medicineObject);
    });
    request.on('doneInProc', function () {
        console.log(o["data"].length)
        res.send(o);
     });
    dbConnection.execSql(request);
});

app.get('/alarms/last',async (req,res)=>{
    var o = {};
    var Request = tedious.Request; 
    var request = new Request("SELECT MAX(alarm_id) FROM alarms",function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
    });
    request.on('row',function(columns){
        columns.forEach(function(column) {
            o["id"] = column.value;
        });
    });
    request.on('doneInProc', function () {
        res.send(o);
     });
    dbConnection.execSql(request);
});
