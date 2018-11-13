<page-admin-page>
  <div class="page page-admin">
  
    <admin-header title="Manage Pages">
      <yield to="right">
        <a href="/admin/page/create" class="btn btn-lg btn-success">
          Create
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">

      <!-- claim grid page -->
      <grid ref="grid" grid={ opts.grid } table-class="table table-bordered table-striped" title="Page Grid" />
      <!-- / claim grid page -->
    
    </div>
  </div>
</page-admin-page>
