<banner-admin-page>
  <div class="content-admin">
  
    <admin-header title="Manage Banners">
      <yield to="right">
        <a href="/admin/banner/create" class="btn btn-lg btn-success">
          Create
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">

      <!-- claim grid page -->
      <grid ref="grid" grid={ opts.grid } table-class="table table-bordered table-striped" title="Banner Grid" />
      <!-- / claim grid page -->
    
    </div>
    
  </div>
</banner-admin-page>
