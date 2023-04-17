describe('ShinyProxy', () => {
  it('main', () => {
    cy.visit()
    cy.screenshot()
  })

  it('psichomics', () => {
    cy.visit()
    cy.contains('psichomics').click()
    cy.screenshot()
    
    cy.visit('/psichomics')
    cy.screenshot()
  })
  
  it('cTRAP', () => {
    cy.visit()
    cy.contains('cTRAP').click()
    cy.screenshot()

    cy.visit('/cTRAP')
    cy.screenshot()
  })
})

describe('Flower dashboard', () => {
  it('open', () => {
    cy.visit('http://localhost:5555/flower/dashboard')
    cy.screenshot()
    cy.contains('celery@ctrap').click()
    cy.screenshot()
  })
})

describe('Grafana', () => {
  it('open', () => {
    cy.visit('http://localhost:3000')
    cy.screenshot()
  })
})

describe('Prometheus', () => {
  it('open', () => {
    cy.visit('http://localhost:9090')
    cy.screenshot()
  })
})

describe('Plausible', () => {
  it('open', () => {
    cy.visit('http://localhost:8000/login')
    cy.screenshot()
  })
})

describe('404', () => {
  it('open', () => {
    cy.request({url: '/404', failOnStatusCode: false}).its('status').should('equal', 404)
    cy.visit('/404', {failOnStatusCode: false})
    cy.screenshot()
  })
})
