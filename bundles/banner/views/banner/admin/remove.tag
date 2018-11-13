<banner-admin-remove-page>
  <div class="page page-banner">
  
    <admin-header title="Remove Banner">
      <yield to="right">
        <a href="/admin/banner" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <form method="post" action="/admin/banner/{ opts.item.id }/remove">
        <div class="card">
          <div class="card-body">
            <p>
              Are you sure you want to delete <b>{ opts.item.id }</b>?
            </p>
          </div>
          <div class="card-footer text-right">
            <button type="submit" class="btn btn-success">Remove Banner</button>
          </div>
        </div>
      </form>
      
    </div>
  </div>
</banner-admin-remove-page>
