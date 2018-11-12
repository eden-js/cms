<banner-admin-remove-page>
  <div class="page page-admin px-3 px-md-4 py-gutter">
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
</banner-admin-remove-page>
