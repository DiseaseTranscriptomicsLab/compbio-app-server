describe('ShinyProxy', () => {
  it('main', () => {
    cy.visit('http://localhost')
    cy.wait(2000)
    cy.screenshot()
  })

  it('psichomics', () => {
    cy.visit('http://localhost')
    cy.wait(2000)
    cy.contains('psichomics').click()
    cy.screenshot()
    
    cy.visit('http://localhost/psichomics')
    cy.wait(2000)
    cy.screenshot()
  })
  
  it('cTRAP', () => {
    cy.visit('http://localhost')
    cy.wait(2000)
    cy.contains('cTRAP').click()
    cy.screenshot()

    cy.visit('http://localhost/cTRAP')
    cy.wait(2000)
    cy.screenshot()
  })
})

describe('Flower dashboard', () => {
  it('open', () => {
    cy.visit('http://localhost:5555/flower/dashboard')
    cy.wait(1000)
    cy.screenshot()
    cy.contains('celery@ctrap').click()
    cy.wait(1000)
    cy.screenshot()
  })
})

describe('Grafana', () => {
  it('open', () => {
    cy.visit('http://localhost:3000')
    cy.wait(1000)
    cy.screenshot()
  })
})

describe('Prometheus', () => {
  it('open', () => {
    cy.visit('http://localhost:9090')
    cy.wait(1000)
    cy.screenshot()
  })
})

describe('Plausible', () => {
  it('open', () => {
    cy.visit('http://localhost:8000')
    cy.wait(1000)
    cy.screenshot()
  })
})

describe('404', () => {
  it('open', () => {
    cy.request({url: '/404', failOnStatusCode: false}).its('status').should('equal', 404)
    cy.visit('/404', {failOnStatusCode: false})
  })
})
