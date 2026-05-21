/*******************************************************************************
 * Script: demo_employee_creation.sql
 * Purpose: Demo simulation of creating an employee in Oracle HRMS
 * Author: Bob
 * Date: 2026-05-21
 * Updated: 2026-05-21 - Added Jira integration documentation
 *
 * Description:
 * This is a demonstration script that simulates the employee creation process
 * and shows expected output without requiring actual Oracle Apps connection.
 *
 * Jira Integration: This file is tracked in Jira project SCRUM
 *******************************************************************************/

SET SERVEROUTPUT ON SIZE 1000000
SET LINESIZE 200

DECLARE
    -- Simulated API Return Variables
    l_person_id                 NUMBER := 12345;
    l_assignment_id             NUMBER := 67890;
    l_per_object_version_number NUMBER := 1;
    l_asg_object_version_number NUMBER := 1;
    l_per_effective_start_date  DATE := SYSDATE;
    l_per_effective_end_date    DATE := TO_DATE('31-DEC-4712', 'DD-MON-YYYY');
    l_full_name                 VARCHAR2(240);
    l_per_comment_id            NUMBER := NULL;
    l_assignment_sequence       NUMBER := 1;
    l_assignment_number         VARCHAR2(30) := 'E12345';
    l_name_combination_warning  BOOLEAN := FALSE;
    l_assign_payroll_warning    BOOLEAN := FALSE;
    l_orig_hire_warning         BOOLEAN := FALSE;
    
    -- Input Parameters (Demo Values)
    l_business_group_id         NUMBER := 101;
    l_hire_date                 DATE := SYSDATE;
    l_first_name                VARCHAR2(150) := 'John';
    l_last_name                 VARCHAR2(150) := 'Doe';
    l_middle_names              VARCHAR2(60) := 'Michael';
    l_email_address             VARCHAR2(240) := 'john.doe@company.com';
    l_employee_number           VARCHAR2(30) := 'EMP001';
    l_sex                       VARCHAR2(30) := 'M';
    l_date_of_birth             DATE := TO_DATE('1990-01-15', 'YYYY-MM-DD');
    l_organization_id           NUMBER := 102;
    l_location_id               NUMBER := 201;
    l_job_id                    NUMBER := 301;
    l_position_id               NUMBER := 401;
    l_grade_id                  NUMBER := 501;
    l_payroll_id                NUMBER := 601;
    l_supervisor_id             NUMBER := 11111;
    
    -- Procedure to simulate API call
    PROCEDURE simulate_employee_creation IS
    BEGIN
        -- Simulate processing
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('ORACLE APPS EMPLOYEE CREATION SIMULATION');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('');
        
        -- Display input parameters
        DBMS_OUTPUT.PUT_LINE('INPUT PARAMETERS:');
        DBMS_OUTPUT.PUT_LINE('------------------');
        DBMS_OUTPUT.PUT_LINE('Business Group ID    : ' || l_business_group_id);
        DBMS_OUTPUT.PUT_LINE('Hire Date            : ' || TO_CHAR(l_hire_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('First Name           : ' || l_first_name);
        DBMS_OUTPUT.PUT_LINE('Middle Name          : ' || NVL(l_middle_names, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Last Name            : ' || l_last_name);
        DBMS_OUTPUT.PUT_LINE('Employee Number      : ' || l_employee_number);
        DBMS_OUTPUT.PUT_LINE('Email Address        : ' || l_email_address);
        DBMS_OUTPUT.PUT_LINE('Gender               : ' || l_sex);
        DBMS_OUTPUT.PUT_LINE('Date of Birth        : ' || TO_CHAR(l_date_of_birth, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Organization ID      : ' || l_organization_id);
        DBMS_OUTPUT.PUT_LINE('Location ID          : ' || NVL(TO_CHAR(l_location_id), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Job ID               : ' || NVL(TO_CHAR(l_job_id), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Position ID          : ' || NVL(TO_CHAR(l_position_id), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Grade ID             : ' || NVL(TO_CHAR(l_grade_id), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Payroll ID           : ' || NVL(TO_CHAR(l_payroll_id), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Supervisor ID        : ' || NVL(TO_CHAR(l_supervisor_id), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('');
        
        -- Simulate API processing
        DBMS_OUTPUT.PUT_LINE('PROCESSING:');
        DBMS_OUTPUT.PUT_LINE('------------------');
        DBMS_OUTPUT.PUT_LINE('> Validating input parameters...');
        DBMS_LOCK.SLEEP(0.5);
        DBMS_OUTPUT.PUT_LINE('> Checking business group...');
        DBMS_LOCK.SLEEP(0.3);
        DBMS_OUTPUT.PUT_LINE('> Validating organization...');
        DBMS_LOCK.SLEEP(0.3);
        DBMS_OUTPUT.PUT_LINE('> Creating person record...');
        DBMS_LOCK.SLEEP(0.5);
        
        -- Build full name
        l_full_name := l_last_name || ', ' || l_first_name;
        IF l_middle_names IS NOT NULL THEN
            l_full_name := l_full_name || ' ' || l_middle_names;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('> Creating assignment record...');
        DBMS_LOCK.SLEEP(0.5);
        DBMS_OUTPUT.PUT_LINE('> Generating employee number...');
        DBMS_LOCK.SLEEP(0.3);
        DBMS_OUTPUT.PUT_LINE('> Committing transaction...');
        DBMS_LOCK.SLEEP(0.3);
        DBMS_OUTPUT.PUT_LINE('');
        
    END simulate_employee_creation;
    
BEGIN
    -- Call simulation procedure
    simulate_employee_creation;
    
    -- Display Results
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE CREATED SUCCESSFULLY!');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('OUTPUT PARAMETERS:');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('Person ID            : ' || l_person_id);
    DBMS_OUTPUT.PUT_LINE('Assignment ID        : ' || l_assignment_id);
    DBMS_OUTPUT.PUT_LINE('Full Name            : ' || l_full_name);
    DBMS_OUTPUT.PUT_LINE('Assignment Number    : ' || l_assignment_number);
    DBMS_OUTPUT.PUT_LINE('Employee Number      : ' || l_employee_number);
    DBMS_OUTPUT.PUT_LINE('Effective Start Date : ' || TO_CHAR(l_per_effective_start_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Effective End Date   : ' || TO_CHAR(l_per_effective_end_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Person OVN           : ' || l_per_object_version_number);
    DBMS_OUTPUT.PUT_LINE('Assignment OVN       : ' || l_asg_object_version_number);
    DBMS_OUTPUT.PUT_LINE('Assignment Sequence  : ' || l_assignment_sequence);
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Check for warnings
    DBMS_OUTPUT.PUT_LINE('WARNINGS:');
    DBMS_OUTPUT.PUT_LINE('------------------');
    IF l_name_combination_warning THEN
        DBMS_OUTPUT.PUT_LINE('⚠ Name combination warning occurred');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✓ No name combination warnings');
    END IF;
    
    IF l_assign_payroll_warning THEN
        DBMS_OUTPUT.PUT_LINE('⚠ Payroll assignment warning occurred');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✓ No payroll assignment warnings');
    END IF;
    
    IF l_orig_hire_warning THEN
        DBMS_OUTPUT.PUT_LINE('⚠ Original hire date warning occurred');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✓ No original hire date warnings');
    END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Display simulated database records
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('SIMULATED DATABASE RECORDS');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('PER_ALL_PEOPLE_F Table:');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('PERSON_ID        : ' || l_person_id);
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE_NUMBER  : ' || l_employee_number);
    DBMS_OUTPUT.PUT_LINE('FULL_NAME        : ' || l_full_name);
    DBMS_OUTPUT.PUT_LINE('FIRST_NAME       : ' || l_first_name);
    DBMS_OUTPUT.PUT_LINE('LAST_NAME        : ' || l_last_name);
    DBMS_OUTPUT.PUT_LINE('EMAIL_ADDRESS    : ' || l_email_address);
    DBMS_OUTPUT.PUT_LINE('SEX              : ' || l_sex);
    DBMS_OUTPUT.PUT_LINE('DATE_OF_BIRTH    : ' || TO_CHAR(l_date_of_birth, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('CURRENT_EMPLOYEE : Y');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('PER_ALL_ASSIGNMENTS_F Table:');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('ASSIGNMENT_ID    : ' || l_assignment_id);
    DBMS_OUTPUT.PUT_LINE('PERSON_ID        : ' || l_person_id);
    DBMS_OUTPUT.PUT_LINE('ASSIGNMENT_NUMBER: ' || l_assignment_number);
    DBMS_OUTPUT.PUT_LINE('ORGANIZATION_ID  : ' || l_organization_id);
    DBMS_OUTPUT.PUT_LINE('JOB_ID           : ' || l_job_id);
    DBMS_OUTPUT.PUT_LINE('POSITION_ID      : ' || l_position_id);
    DBMS_OUTPUT.PUT_LINE('GRADE_ID         : ' || l_grade_id);
    DBMS_OUTPUT.PUT_LINE('LOCATION_ID      : ' || l_location_id);
    DBMS_OUTPUT.PUT_LINE('PAYROLL_ID       : ' || l_payroll_id);
    DBMS_OUTPUT.PUT_LINE('SUPERVISOR_ID    : ' || l_supervisor_id);
    DBMS_OUTPUT.PUT_LINE('ASSIGNMENT_TYPE  : E (Employee)');
    DBMS_OUTPUT.PUT_LINE('PRIMARY_FLAG     : Y');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('NEXT STEPS:');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('1. Verify employee in HRMS forms');
    DBMS_OUTPUT.PUT_LINE('2. Assign additional responsibilities if needed');
    DBMS_OUTPUT.PUT_LINE('3. Set up compensation and benefits');
    DBMS_OUTPUT.PUT_LINE('4. Configure payroll elements');
    DBMS_OUTPUT.PUT_LINE('5. Add contact information');
    DBMS_OUTPUT.PUT_LINE('6. Upload employee photo (optional)');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('DEMO COMPLETED SUCCESSFULLY!');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('ERROR OCCURRED!');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('Error Code    : ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message : ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Common Issues:');
        DBMS_OUTPUT.PUT_LINE('- Invalid Business Group ID');
        DBMS_OUTPUT.PUT_LINE('- Organization not found');
        DBMS_OUTPUT.PUT_LINE('- Missing required setup data');
        DBMS_OUTPUT.PUT_LINE('- Insufficient privileges');
        DBMS_OUTPUT.PUT_LINE('- Date validation errors');
        RAISE;
END;
/

-- Display execution timestamp
SELECT 'Demo executed at: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS execution_time
FROM DUAL;