const express = require('express');
const app = express();
const Sequelize = require('sequelize');

app.use(express.json());

const POSTGRES_URI = 'postgres://postgres:postgrespassword@localhost:5432/postgres';

const server = app.listen(8000, () => {
    console.log("server listening on port 8000");
});

app.post('/blog_post_event', async (req, res) => {
    console.log("Received Event", req.body);
    const blogPostId = req.body.event.data.new.id;
    const sequelize = new Sequelize(POSTGRES_URI, {});
    await sequelize.query('INSERT INTO blog_post_activity(blog_post_id, type) VALUES (:blogPostId, :type)',
        {
            replacements: {
                blogPostId,
                type: 'created'
        }
    });
    res.status(200).send({});
});

