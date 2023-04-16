describe('My First Test', () => {
  it('Test Flower dashboard', () => {
    cy.visit('http://localhost:5555/flower/dashboard')
    cy.wait(2000) // wait 2 seconds
    cy.screenshot()
    cy.contains('celery@ctrap').click()
    cy.wait(2000) // wait 2 seconds
    cy.screenshot()
  })
})
