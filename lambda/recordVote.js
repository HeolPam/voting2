const faunadb = require('faunadb');
const q = faunadb.query;

const client = new faunadb.Client({ secret: process.env.FAUNA_SECRET_KEY });

exports.handler = async function(event, context) {
  const data = JSON.parse(event.body);

  try {
    const response = await client.query(
      q.Create(q.Collection('votes'), { data: data })
    );

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Vote recorded!" }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
