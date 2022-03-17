describe('My First Test', () => {
  it('Visits the Kitchen Sink', () => {
    cy.visit('http://localhost:5555/flower/dashboard')
    cy.wait()
    cy.screenshot()
    cy.contains('celery@ctrap').click()
    cy.wait()
    cy.screenshot()
  })
})
