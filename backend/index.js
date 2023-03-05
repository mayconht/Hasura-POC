const express = require('express');
const app = express();
const Sequelize = require('sequelize');

app.use(express.json());

const POSTGRES_URI = 'postgres://postgres:postgrespassword@localhost:5432/postgres';

const server = app.listen(8000, () => {
    console.log("server listening on port 8000");
});

//event trigger
app.post('/blog_post_event', async (req, res) => {
    console.log("Received Event from blog post", req.body.event.op);
    let type

    switch (req.body.event.op){
        case 'INSERT':
            type = "created";
            break;
        case 'UPDATE':
            if(req.body.event.data.old.is_published && !req.body.event.data.new.is_published){
                type = "unpublished";
            }else if(!req.body.event.data.old.is_published && req.body.event.data.new.is_published){
                type = "published";
            }            
            break;
        case 'DELETE':
            type = "deleted";
            break;
    }

    if(type){
        const sequelize = new Sequelize(POSTGRES_URI, {});
        const blogPostId = req.body.event.data.new.id;

        await sequelize.query(`INSERT INTO blog_post_activity (blog_post_id, type) VALUES ('${blogPostId}', '${type}')`);
    }

    res.send({});
       
    
});


