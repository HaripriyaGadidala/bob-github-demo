-- ============================================================
-- Oracle E-Business Suite HR API
-- Purpose : Create Employee Assignment
-- API     : HR_ASSIGNMENT_API.create_employee_assignment
-- Module  : Oracle Human Resources (HR)
-- ============================================================

DECLARE

  -- ── OUT parameters ────────────────────────────────────────
  l_assignment_id              NUMBER;
  l_object_version_number      NUMBER;
  l_soft_coding_keyflex_id     NUMBER;
  l_comment_id                 NUMBER;
  l_effective_start_date       DATE;
  l_effective_end_date         DATE;
  l_assignment_sequence        NUMBER;
  l_assignment_number          VARCHAR2(30);
  l_other_manager_warning      BOOLEAN;
  l_hourly_salaried_warning    BOOLEAN;
  l_gsp_drop_date_warning      BOOLEAN;
  l_org_now_no_manager_warning BOOLEAN;
  l_no_managers_warning        BOOLEAN;
  l_spp_delete_warning         BOOLEAN;
  l_payroll_id_warning         BOOLEAN;

BEGIN

  HR_ASSIGNMENT_API.create_employee_assignment (
    -- ── Mandatory IN parameters ──────────────────────────
    p_effective_date              => TO_DATE('2024-01-01', 'YYYY-MM-DD'),
    p_business_group_id           => 101,           -- Your Business Group ID
    p_person_id                   => 12345,         -- Employee Person ID
    p_organization_id             => 200,           -- Organization/Department ID
    p_assignment_status_type_id   => 1,             -- Active Assignment status ID

    -- ── Optional IN parameters ───────────────────────────
    p_grade_id                    => NULL,          -- Grade ID (optional)
    p_position_id                 => NULL,          -- Position ID (optional)
    p_job_id                      => 50,            -- Job ID
    p_location_id                 => 75,            -- Location ID
    p_payroll_id                  => 300,           -- Payroll ID (optional)
    p_pay_basis_id                => NULL,          -- Pay Basis ID (optional)
    p_employment_category         => 'FR',          -- FR=Full-time Regular, PR=Part-time Regular
    p_manager_flag                => 'N',           -- Y/N
    p_primary_flag                => 'Y',           -- Y if this is the primary assignment
    p_date_probation_end          => NULL,
    p_normal_hours                => 40,            -- Standard working hours per week
    p_frequency                   => 'W',           -- W=Weekly, M=Monthly
    p_supervisor_id               => NULL,          -- Supervisor Person ID (optional)
    p_notice_period               => NULL,
    p_notice_period_uom           => NULL,
    p_employee_category           => NULL,
    p_work_at_home                => NULL,
    p_job_post_source_name        => NULL,
    p_assignment_number           => NULL,          -- Auto-generated if NULL
    p_change_reason               => NULL,
    p_comments                    => 'Created via HR API',

    -- ── OUT parameters ───────────────────────────────────
    p_assignment_id               => l_assignment_id,
    p_object_version_number       => l_object_version_number,
    p_soft_coding_keyflex_id      => l_soft_coding_keyflex_id,
    p_comment_id                  => l_comment_id,
    p_effective_start_date        => l_effective_start_date,
    p_effective_end_date          => l_effective_end_date,
    p_assignment_sequence         => l_assignment_sequence,
    p_assignment_number           => l_assignment_number,
    p_other_manager_warning       => l_other_manager_warning,
    p_hourly_salaried_warning     => l_hourly_salaried_warning,
    p_gsp_drop_date_warning       => l_gsp_drop_date_warning,
    p_org_now_no_manager_warning  => l_org_now_no_manager_warning,
    p_no_managers_warning         => l_no_managers_warning,
    p_spp_delete_warning          => l_spp_delete_warning,
    p_payroll_id_warning          => l_payroll_id_warning
  );

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Assignment created successfully.');
  DBMS_OUTPUT.PUT_LINE('Assignment ID           : ' || l_assignment_id);
  DBMS_OUTPUT.PUT_LINE('Assignment Number       : ' || l_assignment_number);
  DBMS_OUTPUT.PUT_LINE('Object Version Number   : ' || l_object_version_number);
  DBMS_OUTPUT.PUT_LINE('Effective Start Date    : ' || l_effective_start_date);
  DBMS_OUTPUT.PUT_LINE('Effective End Date      : ' || l_effective_end_date);

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error creating assignment: ' || SQLERRM);
    RAISE;
END;
/