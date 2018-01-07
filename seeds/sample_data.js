exports.seed = async function (knex) {
  await knex('services').del()
  await knex('services').insert({
    id: 1,
    name: 'Crime incidents',
    slug: 'crime-incidents',
    endpoint: 'https:\\/\\/phl.carto.com\\/api\\/v2\\/sql\\?q=.+',
    subject_template: '{{data.rows.length}} crimes',
    body_template: `
      {{#if data.rows.length}}
        <h1>Crime incidents</h1>
        <ul>
        {{#each data.rows}}
          <li>{{text_general_code}} on {{location_block}}</li>
        {{/each}}
        </ul>
      {{/if}}
    `
  })

  await knex('queries').del()
  await knex('queries').insert([
    {
      id: 1,
      service_id: 1,
      url: `https://phl.carto.com/api/v2/sql?q=SELECT * FROM incidents_part1_part2 WHERE dc_dist = '24' AND dispatch_date >= '{{formatDate '2 days ago' 'YYYY-MM-DD'}}'`
    },
    {
      id: 2,
      service_id: 1,
      url: `https://phl.carto.com/api/v2/sql?q=SELECT * FROM incidents_part1_part2 WHERE dc_dist = '25' AND dispatch_date >= '{{formatDate '2 days ago' 'YYYY-MM-DD'}}'`
    }
  ])

  await knex('subscribers').del()
  await knex('subscribers').insert([
    {
      id: 1,
      query_id: 1,
      email: 'subscribeme-a@mailinator.com'
    },
    {
      id: 2,
      query_id: 1,
      email: 'subscribeme-b@mailinator.com'
    },
    {
      id: 3,
      query_id: 2,
      email: 'subscribeme-c@mailinator.com'
    }
  ])
}
