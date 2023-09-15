<%@ page import="vn.edu.iuh.fit.week01_lab_laminhtam_21023911.model.Account" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="vn.edu.iuh.fit.week01_lab_laminhtam_21023911.repository.AccountRepository" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.edu.iuh.fit.week01_lab_laminhtam_21023911.model.Grant_access" %>
<%@ page import="vn.edu.iuh.fit.week01_lab_laminhtam_21023911.repository.Grant_accessRepository" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="vn.edu.iuh.fit.week01_lab_laminhtam_21023911.model.Role" %>
<%@ page import="vn.edu.iuh.fit.week01_lab_laminhtam_21023911.repository.RoleRepository" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
</head>
<body>
<%!
    public String getStatusString(int statusCode) {
        String status = "";
        switch (statusCode) {
            case 1:
                status = "active";
                break;
            case 0:
                status = "deactive";
                break;
            case -1:
                status = "xóa";
                break;
        }
        return status;
    }
%>

<%!
    public List<Long> getGrantedRoleIdsForAccount(Long accountId) {
        List<Long> grantedRoles = new ArrayList<>();
        for (Grant_access grantAccess : allGrantAccesses) {
            if (grantAccess.getAccount_id().equals(accountId) && grantAccess.isIs_grant()) {
                grantedRoles.add(grantAccess.getRole_id());
            }
        }
        return grantedRoles;
    }
%>

<%!
    public String getRoleNameById(Long roleId) {
        for (Role role : allRoles) {
            if (role.getRole_id().equals(roleId)) {
                return role.getRole_name();
            }
        }
        return "";
    }
%>

<%!
    public String getRoleNamesForAccount(Long accountId) {
        List<String> roleNames = new ArrayList<>();
        List<Long> grantedRoleIds = getGrantedRoleIdsForAccount(accountId);
        for (Long roleId : grantedRoleIds) {
            String roleName = getRoleNameById(roleId);
            if (!roleName.isEmpty()) {
                roleNames.add(roleName);
            }
        }
        return String.join(",", roleNames);
    }
%>

<%!
    AccountRepository accountRepository = new AccountRepository();
    Grant_accessRepository grantAccessRepository = new Grant_accessRepository();
    RoleRepository roleRepository = new RoleRepository();
    List<Account> allAccount = accountRepository.findAll();
    List<Grant_access> allGrantAccesses = grantAccessRepository.findAll();
    List<Role> allRoles = roleRepository.findAll();
%>

<%
    Account account = (Account) session.getAttribute("account");
    PrintWriter printWriter = response.getWriter();
%>

<p>id: <%= account.getAccount_id() %>
</p>
<p>fullName: <%= account.getFullName() %>
</p>
<p>email: <%= account.getEmail() %>
</p>
<p>phone: <%= account.getPhone() %>
</p>
<p>status: <%= getStatusString(account.getStatus()) %>
</p>

<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modal">
    add account
</button>
<% Account newAccount = new Account(); %>
<!-- Modal -->
<div class="modal fade" id="modal" tabindex="-1" aria-labelledby="modal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="ControlServlet" method="post">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalTitle">Add New Account</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <input type="hidden" name="action" value="add-account">
                        <label for="account_idInput" class="form-label">Id</label>
                        <input type="text" class="form-control" name="account_id" id="account_idInput"
                               value="<%= allAccount.size() + 1 %>"
                               readonly>
                        <label for="emailInput" class="form-label">Email address</label>
                        <input type="email" class="form-control" name="email" id="emailInput"
                               placeholder="name@example.com">
                        <label for="fullNameInput" class="form-label">FullName</label>
                        <input class="form-control" name="fullName" id="fullNameInput">
                        <label for="passwordInput" class="form-label">Password</label>
                        <input class="form-control" name="password" id="passwordInput">
                        <label for="phoneInput" class="form-label">Phone</label>
                        <input class="form-control" name="phone" id="phoneInput">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <input type="submit" class="btn btn-primary" value="add account">
                </div>
            </form>
        </div>
    </div>
</div>

<table class="table">
    <thead>
    <th>#</th>
    <th>id</th>
    <th>fullName</th>
    <th>email</th>
    <th>phone</th>
    <th>status</th>
    <th>role</th>
    </thead>
    <tbody>
    <%
        int length = allAccount.size();
        for (int i = 0; i < length; i++) {
            Account curAccount = allAccount.get(i);
    %>
    <tr>
        <td>
            <%= i + 1%>
        </td>
        <td>
            <%= curAccount.getAccount_id() %>
        </td>
        <td>
            <%= curAccount.getFullName() %>
        </td>
        <td>
            <%= curAccount.getEmail() %>
        </td>
        <td>
            <%= curAccount.getPhone() %>
        </td>
        <td>
            <%= getStatusString(curAccount.getStatus())%>
        </td>
        <td>
            <%= getRoleNamesForAccount(curAccount.getAccount_id()) %>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

</body>
</html>
