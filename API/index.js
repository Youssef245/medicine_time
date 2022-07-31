import express from 'express';
import bodyParser from 'body-parser';
import dbConnection from './connection.js';
import tedious from 'tedious';

var jsonParser = bodyParser.json()

const PORT = 8080;
const app = express();

app.use(express.json())
app.use(express.urlencoded({ extended: true }))

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

app.post('/loginRequest',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var found = false;
    var o = {};
    var request = new Request(`select users.id , users.name from users where name = '${body.name}' and 
    password = '${body.password}' `,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
    });

    request.on('row',function(columns){
        columns.forEach(function(column) {
            o[column.metadata.colName] = column.value;
        });
    });
    request.on('doneInProc', function () {
        res.send(o);
     });
    dbConnection.execSql(request);
});

app.post('/measures',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var request = new Request(`insert into measures(user_id,pressure,glucose,random_glucose,
        sodium,potassium,phosphate,createnin,hemoglobin,weight,inserted_date,calcium,range)
     VALUES (${body.user_id},'${body.pressure}'
    ,${body.glucose},${body.random_glucose},${body.sodium},${body.potassium},${body.phosphate}
    ,${body.createnin},${body.hemoglobin},${body.weight},'${body.inserted_date}',${body.calcium},
    ${body.range})`,function(err){
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

app.get('/sideeffects',async (req,res)=>{
    var o = {};
    o["data"]=[];
    var Request = tedious.Request; 
    var request = new Request("SELECT side_effect.effect , side_category.cat_name from side_effect , "+
    "side_category where side_category.cat_id = side_effect.cat_id",function(err){
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

app.post('/ask',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var request = new Request(`insert into ask_ques (user_id,question,towho,date)
     VALUES (${body.user_id},N'${body.question}'
    ,N'${body.towho}','${body.date}')`,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                question : 'Created Successfully'
            });
        }
    });

    dbConnection.execSql(request);
});

app.get('/questions/:user_id',async (req,res)=>{
    var param = req.params;
    var o = {};
    o["data"]=[];
    var Request = tedious.Request; 
    var request = new Request(`select user_id
    ,question ,towho,answers,date from ask_ques where user_id= ${param.user_id} order by date DESC`,function(err){
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
            medicineObject[column.metadata.colName] = column.value;
        });
        o["data"].push(medicineObject);
    });
    request.on('doneInProc', function () {
        console.log(o["data"].length)
        res.send(o);
     });
    dbConnection.execSql(request);
}); 

app.post('/effects',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var request = new Request(`insert into user_effects (user_id,kidney_effects,effects)
     VALUES (${body.user_id},N'${body.kidney_effects}',N'${body.effects}')`,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                effect : 'Created Successfully'
            });
        }
    });

    dbConnection.execSql(request);
});

app.post('/survey',(req, res)=>{
    var body = req.body;
    var Request = tedious.Request; 
    var request = new Request(`insert into survey (user_id,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,s_date)
     VALUES (${body.user_id},N'${body.q1}',N'${body.q2}',N'${body.q3}',N'${body.q4}',N'${body.q5}',
     N'${body.q6}',N'${body.q7}',N'${body.q8}',N'${body.q9}',N'${body.q10}','${body.date}')`,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                survey : 'Created Successfully'
            });
        }
    });

    dbConnection.execSql(request);
});

app.get('/users/:id',async (req,res)=>{
    var o = {};
    var param = req.params;
    var Request = tedious.Request; 
    var request = new Request(`
    select ISNULL(mobile,'') as mobile,ISNULL(email,'') as email, ISNULL(height,'') as height, ISNULL(birth_date,'') as birth_date, ISNULL(education_level,'') as education_level
    , ISNULL(gendar,'') as gendar, ISNULL(pressure,'') as pressure, ISNULL(glucose,'') as glucose, ISNULL(chl,'') as chl
    , ISNULL(liver,'') as liver, ISNULL(heart,'') as heart, ISNULL(hemoglobin,'') as hemoglobin, ISNULL(cancer,'') as cancer
    , ISNULL(manaya,'') as manaya, ISNULL(glucose_stage,'') as glucose_stage, ISNULL(heart_type,'') as heart_type, ISNULL(cancer_type,'') as cancer_type
    ,ISNULL(manaya_type,'') as manaya_type, ISNULL(kidney_period,'') as kidney_period,ISNULL(kidney_stage,'') as kidney_stage, ISNULL(kidney_transplant,'') as kidney_transplant
    ,ISNULL(password,'') as password, ISNULL(transplant,'') as transplant,ISNULL(liver_type,'') as liver_type  from users  where id = ${param.id}
    `,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
    });
    request.on('row',function(columns){
        columns.forEach(function(column) {
            o[column.metadata.colName] = column.value;
        });
    });
    request.on('doneInProc', function () {
        res.send(o);
     });
    dbConnection.execSql(request);
});



app.post('/users/:id',async (req,res)=>{
    var param = req.params;
    var body = req.body;
    var Request = tedious.Request; 
    var request = new Request(`
    update users set
       name= N'${body.name}'
      ,password= N'${body.password}'
      ,mobile= N'${body.mobile}'
      ,email= N'${body.email}'
      ,height= ${body.height}
      ,gendar= N'${body.gendar}'
      ,education_level= N'${body.education_level}'
      ,birth_date= N'${body.birth_date}'
      ,pressure= ${body.pressure}
      ,glucose= ${body.glucose}
      ,chl= ${body.chl}
      ,heart= ${body.heart}
      ,liver= ${body.liver}
	  ,hemoglobin= ${body.hemoglobin}	
      ,cancer= ${body.cancer}
      ,manaya= ${body.manaya}
	  ,glucose_stage= N'${body.glucose_stage}'
      ,heart_type= N'${body.heart_type}'
      ,cancer_type= N'${body.cancer_type}'
      ,manaya_type= N'${body.manaya_type}'
      ,kidney_period= N'${body.kidney_period}'
      ,kidney_stage= N'${body.kidney_stage}'
      ,kidney_transplant= N'${body.kidney_transplant}'
      ,transplant= N'${body.transplant}'
      ,liver_type= N'${body.liver_type}'
      FROM users where id = ${param.id}
    `,function(err){
        if(err)
        {
            res.send({
                error : err
            });
        }
        else{
            res.send({
                survey : 'Created Successfully'
            });
        }
    });
    dbConnection.execSql(request);
});

