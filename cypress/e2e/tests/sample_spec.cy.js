describe('ShinyProxy', () => {
  it('main', () => {
    cy.visit('http://localhost')
    cy.screenshot()
  })

  it('psichomics', () => {
    cy.visit('http://localhost')
    cy.contains('psichomics').click()
    cy.screenshot()
    
    cy.visit('http://localhost/psichomics')
    cy.screenshot()
  })
  
  it('cTRAP', () => {
    cy.visit('http://localhost')
    cy.contains('cTRAP').click()
    cy.screenshot()

    cy.visit('http://localhost/cTRAP')
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
