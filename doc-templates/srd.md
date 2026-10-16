This is Apiary's SRD section template; a Project may replace it through `srd_template`. A replacement should keep the Glossary, numbered SR groups and Test Fixtures, because req-review and write-plan use the shared terms, requirements and test infrastructure.

## SRD section template

Organize requirements by domain or concern, rather than by PRD section. Use numbered SR groups and subsections, with one clear requirement per statement.

```markdown
# [Feature or Project Name] Software Requirements

## Glossary
Use the PRD's Glossary terms consistently. Define additional software terms only
when this SRD gives them a particular meaning, and write them in Title Case.

## SR-1: [Domain Name]

### SR-1.1: [Specific Concern]
State what must be true about the software, including the applicable constraints.

### SR-1.2: [Another Concern]
State the next distinct, verifiable obligation.

## SR-N: Test Fixtures
Describe the test infrastructure and the additions this feature requires,
following the Test Fixtures guidance below.
```

Derive the groups from the PRD. Common concerns include the following; include those the change needs:

- **Data Model:** state the required fields, types, constraints, serialization and affected entities.
- **Configuration:** state required schema changes, validation and resolution behaviour.
- **API / Commands:** state required interfaces, parameters, results and availability.
- **Execution / Processing:** state runtime behaviour, lifecycle and process-management constraints.
- **Validation / Linting:** state required checks and their integration with existing validation.
- **Existing Behaviour:** state the behaviour the input requires preserving.
- **Documentation:** state which documentation the feature requires after implementation.

## Test Fixtures

Every SRD includes this section, sized to the feature and grounded in the code and test guidance. An implementor should know which helpers and fixtures to use and where tests belong.

1. Identify where relevant fixtures, helpers, constants and test documentation live.
2. Name the existing factories and fixtures tests must reuse, following established conventions instead of hardcoding shared setup and values.
3. Specify the capabilities and parameters existing helpers need to support the feature.
4. Identify required new fixtures and where they belong.
5. Identify existing test files to extend and any new test files needed.

Describe the needed infrastructure where it does not yet exist, distinguishing required additions from existing helpers. State when a category needs no additions.
